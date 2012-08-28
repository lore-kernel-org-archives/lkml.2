Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab2H1RF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:05:59 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47963 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2H1RF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:05:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUXTngUZp2c2dLVRZjFxhXD9e+XYW6Pn0zaHvMt0fB+eA@mail.gmail.com>
References: <1340736849-14875-1-git-send-email-yinghai@kernel.org>
 <1340736849-14875-3-git-send-email-yinghai@kernel.org> <CAE9FiQVrUbEzopKfeoQZFNdNszLN96brC+rYuGXQCfZvpi_ETQ@mail.gmail.com>
 <CAE9FiQUXTngUZp2c2dLVRZjFxhXD9e+XYW6Pn0zaHvMt0fB+eA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Aug 2012 10:05:35 -0700
X-Google-Sender-Auth: xneGrcN6zZ6HdJPWaOtMoM_ndFs
Message-ID: <CA+55aFxLUExCZE1=gQpDT0ip9s+iMRYEVK2QjdCGNk9iympfYA@mail.gmail.com>
Subject: Re: [PATCH -v12 02/15] resources: Add probe_resource()
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

On Tue, Aug 28, 2012 at 9:09 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> please check update one. -v7

Ugh. Ok, looking closer at this, I think I agree with Bjorn. This is too ugly.

The whole "reduce size/needed_size by 1" double loop is O(n**2). And
it does ugly "insert fake resource to check, and then remove it". Ugh.

Maybe this works in practice for the special case of some PCI bus
numbers that are small integers, but the code is nasty nasty horrible
and not a generic resource allocation thing.

                Linus
