Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab2LNLVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:21:49 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36783 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab2LNLVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:21:48 -0500
Date: Fri, 14 Dec 2012 11:26:57 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Denis Kirjanov <kirjanov@gmail.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 12/12] edac: fix kernel panic on module unloading
Message-ID: <20121214112657.6c1b74e9@pyramind.ukuu.org.uk>
In-Reply-To: <20121214110310.11019.21098.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
	<20121214110310.11019.21098.stgit@zurg>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2012 15:03:10 +0400
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch fixes use-after-free and double-free bugs in edac_mc_sysfs_exit().
> mci_pdev has single reference and put_device() calls mc_attr_release() which
> calls kfree(), thus following device_del() works with already released memory.
> An another kfree() in edac_mc_sysfs_exit() releses the same memory again. Great.

Patches for this were posted a while ago by Jean Delvare. See bugzilla
50491 as well for this.


