Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752470Ab3AAX70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 18:59:26 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50038 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666Ab3AAX7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 18:59:23 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH] p54pci: don't return zero on failure path in p54p_probe()
Date: Wed, 2 Jan 2013 00:53:18 +0100
User-Agent: KMail/1.13.7 (Linux/3.8.0-rc1-wl+; KDE/4.8.4; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
References: <1357074661-15784-1-git-send-email-khoroshilov@ispras.ru> <201301012245.43064.chunkeey@googlemail.com> <50E366D6.7040709@ispras.ru>
In-Reply-To: <50E366D6.7040709@ispras.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301020053.18704.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 January 2013 23:44:38 Alexey Khoroshilov wrote:
> On 01/02/2013 01:45 AM, Christian Lamparter wrote:
> > On Tuesday 01 January 2013 22:11:01 Alexey Khoroshilov wrote:
> >> If pci_set_dma_mask() or pci_set_consistent_dma_mask() fails in p54p_probe(),
> >> it breaks off initialization, deallocates all resources, but returns zero.
> >>
> >> The patch implements proper error code propagation.
> > Uh, Thanks!
> >
> > But wait, I think there's another return 0 in the error
> > path. See p54pci.c @ line 558:
> >
> > mem_len = pci_resource_len(pdev, 0);
> > if (mem_len < sizeof(...)) {
> > 	dev_err(...)
> > 	goto err_disabled_dev;
> > }
> >
> > Do you think you can add a err = -EINVAL; before the goto too?
> You are right! But I would say -ENODEV is more popular error code in 
> this case.
pci_* functions seem to use a lot of -EIO too. Either way shouldn't
really matter. So, let's make it -ENODEV.
 
> > [I wonder why this wasn't found by the verification project as
> > well? Could it be that pci_resource_len(...) < sizeof(...) is
> > somehow always true and this is a dead branch?]
> Actually it was found, but I have no direct access to the results at the 
> moment. My fault.
> 
> Would you like I resend the patch to fix both?
:)

Don't forget the ACKed-by tag from the previous reply!

Thanks

Christian
