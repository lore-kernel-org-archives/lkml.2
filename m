Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab2KEUCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:02:09 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:57847 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2KEUCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:02:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH] drivers/misc/kgdbts.c: remove eprintk
Date: Mon, 5 Nov 2012 20:01:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: walter harms <wharms@bfs.de>, kernel-janitors@vger.kernel.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <201211051626.29317.arnd@arndb.de> <alpine.DEB.2.02.1211051754080.1973@hadrien>
In-Reply-To: <alpine.DEB.2.02.1211051754080.1973@hadrien>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201211052001.49672.arnd@arndb.de>
X-Provags-ID: V02:K0:D7n883slHL5LrEzu6bqlPLZqrEHrwuBbCSVsZFqNsHw
 nTkqJN4bJmweQQgzL5INvBbq4PyNXSBM7he84VV/0B1bx3oBZu
 czIQPTYaVaw/QufxSnPFBTk7mc6ZNmlHpHcG2+hMtKN1xlPMlo
 0Ferd1LZ8rsH/KBmWLuYQhhipGLLwf9Ahs8aYg98PnQSY48Bqy
 2tcf08I+YyaVodVaZPuP1QXij7yBJXFs5yklyIz98JSYRzZNsg
 FDys5mGTCA+BToVnasmY6ahYzxzq/ZiUW/xCWSgGnHAj5SmaIr
 +cr3eVFU9Dcy3mvQumPN3IkZ1ldnVh3TnXcjAHYtbDObRWVvsa
 7gPMKU2uz/fA1LqZE2B0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2012, Julia Lawall wrote:
> OK, I could try proposing that, and if someone doesn't think it is the
> right thing to do, they can ignore the patch.
> 
> Concretely, KERN_WARNING should be added in the printk called from WARN,
> and all KERN information should be removed from the calls?

I think that would be the right solution, yes. Unfortunately, I don't
know how to easily do this since we are already passing down a format
string into vprintk here. Maybe just add the KERN_WARNING at the point
where __WARN_printf gets called.

	Arnd
