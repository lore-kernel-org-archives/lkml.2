Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752783Ab1AIVc1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 16:32:27 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:38351 "EHLO
	smtp3.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1AIVcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:32:25 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 smtp3.sgsi.ucl.ac.be C24211C60A2
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?iso-8859-1?q?Universit=E9_Catholique_de?= Louvain
To: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
Date: Sun, 9 Jan 2011 22:32:18 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.5; x86_64; ; )
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be> <20110109130608.5c7bb4b0.rdunlap@xenotime.net>
In-Reply-To: <20110109130608.5c7bb4b0.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101092232.19171.christoph.paasch@uclouvain.be>
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: C24211C60A2.00000
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sunday, January 09, 2011 wrote Randy Dunlap:
> On Sun,  9 Jan 2011 21:55:34 +0100 Christoph Paasch wrote:
> If there is something in net/tcp.h that uses data or functions from
> <linux/list.h>, then <linux/list.h> should be #included in net/tcp.h,
> whether some other file pulls it in indirectly or not.
> 
> etc. etc. etc.
Why?

IMHO I think that it increases compile-time.
Ok, here in that case it only increases it slightly (probably it isn't even 
measurable). But, if *all* the files would be more strict in including, I'm 
sure that it would make a difference.
The less files you include, the faster the compilation will be.

In net/tcp.h there were even 4 unnecessary included files.

And, then we would also need to include:
net/net_namespace.h (for struct net)

Also, I think that it makes the code more readable and also easier to 
maintain. The more files we include, the bigger the chance is that we will end 
up with plenty of files unnecessarily included, and thus the compile-time will 
explode.

Regards,
Christoph

--
Christoph Paasch
PhD Student

IP Networking Lab --- http://inl.info.ucl.ac.be
MultiPath TCP in the Linux Kernel --- http://inl.info.ucl.ac.be/mptcp
Université Catholique de Louvain

www.rollerbulls.be
--
