Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2FZTBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 15:01:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:43610 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2FZTBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 15:01:41 -0400
MIME-Version: 1.0
In-Reply-To: <1340736849-14875-2-git-send-email-yinghai@kernel.org>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org> <1340736849-14875-2-git-send-email-yinghai@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jun 2012 12:01:19 -0700
X-Google-Sender-Auth: -RsGbQYldX1B_hgQRNmrv_hT9HI
Message-ID: <CA+55aFzi7tHg=3k8Fmga8XmxFbn6tZLLV97vt67Xx_WtckQo6g@mail.gmail.com>
Subject: Re: [PATCH -v12 01/15] resources: Split out __allocate_resource()
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>, David Miller <davem@davemloft.net>,
        x86 <x86@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 11:53 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> It will take bool lock, so we could use it in other functions that
> hold the resource lock already.

This is too damn ugly.

These kinds of "conditionally take lock" things are always just bugs
waiting to happen. Don't do it.

Just make the rule be that the caller of the __allocate_resource
helper has to hold the lock. Sure, that means that you need to then
use split reallocate_resource() into a helper function (ie a static
__reallocate_resource() that needs to have the lock taken by the
caller too), but dammit, that's definitely the right thing to do
anyway.

These kinds of "bool lock" crap things have to die. They are *wrong*.
They are a sign of bad locking rules.

                  Linus
