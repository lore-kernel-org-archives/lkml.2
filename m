Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab0CUIdc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 04:33:32 -0400
Received: from web110307.mail.gq1.yahoo.com ([67.195.8.207]:30673 "HELO
	web110307.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751267Ab0CUIda convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 04:33:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Nd8v2C/0/o0Gs2bI1ZEYq7x3sXAjFjMEW4E+Et84XPXP9q+bB62rzPot0FJBQ55C+8vYLxtmOl/2Wcfd8obPYuhcZU8uBipZY2o6/nNTE1bFixs7oA6CDhGFCEb5LZQC7S+rcjgsbzMohoU7+QKF3xoxXIdefmnOB1jLZwZMPUg=;
Message-ID: <876436.86374.qm@web110307.mail.gq1.yahoo.com>
X-YMail-OSG: yEZ5puYVM1kthGzme26BAVYZlMY45qwOsATxlgylkk.WZN8
 5ER5ijB0fD6QwPH_Y9as4IktsD7sCIhM_36jqDbgXBHTO7GCPvj68QXl1YHx
 Ws4wHMOHXBRiohN6e8dr.xP6.hRmV8GmEWhrVO1yLL5riJDsUlrxmZHRes6Y
 xM5AqLQgPe_oWRcm8cFjbqmk2iqzH4ImM3FkT6IPW4m0up8vkRs7EGSthSFx
 1LQrvxJiZ5TElivkSuGWRL2JmHrmk9ZduQ57IkEffuE1bKYiaL5P0rnA.tFG
 cmQAxoad8f6tspAieDStKS1JHBE0RSsQuXVBlRV_noAVVJbHA2FuhzlyhMUz
 RvqKpJL4i_PtuBDMFM7nsyQ--
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Sun, 21 Mar 2010 01:33:28 -0700 (PDT)
From: Valery Reznic <valery_reznic@yahoo.com>
Subject: Re: execve for script don't return ENOEXEC, bug ?
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4BA50C76.9070603@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--- On Sat, 3/20/10, David Newall <davidn@davidnewall.com> wrote:

> From: David Newall <davidn@davidnewall.com>
> Subject: Re: execve for script don't return ENOEXEC, bug ?
> To: "Valery Reznic" <valery_reznic@yahoo.com>
> Cc: linux-kernel@vger.kernel.org
> Date: Saturday, March 20, 2010, 7:57 PM
> Valery Reznic wrote:
> > execve's man page state that script's interprtert
> should not be interpreter itself:
> >
> ------------------------------------------------------
> >    Interpreter scripts
> >        An  interpreter 
> script  is  a  text  file  that has
> execute permission
> >        enabled and whose first
> line is of the form:
> > 
> >            #!
> interpreter [optional-arg]
> > 
> >        The interpreter must be a
> valid pathname for an executable which is not
> >        itself  a 
> script.
> ------------------------------------------------------
> > 
> > I.e, execve should return ENOEXEC. And it did it at
> least in Fedora 8 and earlier.
> > 
> > To me it looks like  execve and it's man page
> disagree. Do you know is it new intended behaviour of execve
> and just man page wasn't update or it's a bug in execve ?
> 
> Code and man pages do sometimes disagree.  I shan't
> address what the correct behaviour is, because if you ask
> three people you're sure to get four different answers,
> rather let's discuss what is desirable.  Without
> looking at how it works, we observe that a.sh can be
> executed without error.  If a.out were written in C it
> would qualify as an acceptable interpreter according to the
> man page, so why should it not qualify if it is
> interpreted?  I think it's desirable that it does
> qualify.  There could be sound reasons why only one
> level of interpreter can be invoked.  Perhaps loading a
> script interpreter is done as an exception in exec, and it's
> too ugly to allow recursive exceptions.  That would be
> a fair reason.  But if there's no reason, then don't
> have the restriction*.  Linux now apparently does
> permit interpreted interpreters, and I say that is the
> desirable result.
For some reason I tough that ENOEXEC for 'interpreted interpreter' is posix requirement. But after closer look it appear to be only arbitrary restriction now lifted in Linux.

I had a look at the source http://tomoyo.sourceforge.jp/cgi-bin/lxr/source/fs/binfmt_misc.c
and it's obvious that 'interpreted interpreter' is intentional (and recursion depth is 4).
So, execve is behave as it should and only man page is lag behind.
Thank you for you help/


Just curios - who use this feature in the real world and what for ?

Valery.
> 
> *Newall's second rule of programming: A program should
> impose no unnecessary restriction on its user.
> 


      
