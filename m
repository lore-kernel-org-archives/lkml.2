Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770Ab1AIWdb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 17:33:31 -0500
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:33009 "EHLO
	smtp1.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548Ab1AIWda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 17:33:30 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 smtp1.sgsi.ucl.ac.be 78235E97E2
From: Christoph Paasch <christoph.paasch@uclouvain.be>
Reply-To: christoph.paasch@uclouvain.be
Organization: =?iso-8859-1?q?Universit=E9_Catholique_de?= Louvain
To: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] Cleanup include/net/tcp.h include-files and coding-style
Date: Sun, 9 Jan 2011 23:33:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.5; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1294606534-28522-1-git-send-email-christoph.paasch@uclouvain.be> <201101092232.19171.christoph.paasch@uclouvain.be> <1294610141.2823.31.camel@localhost>
In-Reply-To: <1294610141.2823.31.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201101092333.19406.christoph.paasch@uclouvain.be>
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 78235E97E2.00000
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sunday, January 09, 2011 wrote Ben Hutchings:
> The cost of repeated inclusion is minimal.  GCC's preprocessor
> recognises when the entire content of a file is conditional on #ifndef
> FOO and will not even open it again if FOO is defined.
Thanks, I did not knew about that.

> If a file directly references definitions that are supposed to be
> provided by a certain header, changing it to rely on indirect inclusion
> of that header generally does *not* aid maintenance.
But then, to be coherent, we would need to add the following includes (and I'm 
even not 100% sure if it's all we need):

linux/percpu_counter.h (needed for percpu_counter_sum_positive)
linux/mm_types.h (needed for struct page)
linux/aio.h (needed for struct kiocb)
net/inet_sock.h (needed for struct ip_options)
linux/pipe_fs_i.h (needed for struct pipe_inode_info)
linux/poll.h (needed for struct poll_table_struct)
linux/compiler.h (needed for __percpu)

IMO there should be a clear rule for the inclusion of files.

Personally I think it's best to include as few files as possible. Because I 
think, that this reduces the risk of including a file, whose structs/functions 
aren't even referenced (it's easier to manually check if one include out of 10 
is useless, than checking it for 50).

But ok, there may be other stronger reasons for the opposite.
What are the reasons for including these files?

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
