Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933712Ab2EWP6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 11:58:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53640 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab2EWP6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 11:58:06 -0400
MIME-Version: 1.0
In-Reply-To: <1337754877-19759-3-git-send-email-yinghai@kernel.org>
References: <1337754877-19759-1-git-send-email-yinghai@kernel.org> <1337754877-19759-3-git-send-email-yinghai@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 May 2012 08:57:41 -0700
X-Google-Sender-Auth: _jbEBN2rfa8aSlAcP0JPZnOgT8k
Message-ID: <CA+55aFzd1BWqidt95qZLc1x_YU=WeGS=mKUOMvO_3omOhc_5VA@mail.gmail.com>
Subject: Re: [PATCH 02/11] PCI: Try to allocate mem64 above 4G at first
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 11:34 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> and will fall back to below 4g if it can not find any above 4g.

Has this been tested on 32-bit machines without PAE? There might be
things that just happen to work because their allocations were always
done bottom-up.

Or do we have something else that protects us from the "oops, we can't
actually *map* those pages"?

                       Linus
