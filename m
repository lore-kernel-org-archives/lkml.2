Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab0CTR5Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:57:16 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:42324 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab0CTR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:57:15 -0400
Message-ID: <4BA50C76.9070603@davidnewall.com>
Date: Sun, 21 Mar 2010 04:27:10 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Valery Reznic <valery_reznic@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: execve for script don't return ENOEXEC, bug ?
References: <435973.80037.qm@web110306.mail.gq1.yahoo.com>
In-Reply-To: <435973.80037.qm@web110306.mail.gq1.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valery Reznic wrote:
> execve's man page state that script's interprtert should not be 
> interpreter itself:
> ------------------------------------------------------
>    Interpreter scripts
>        An  interpreter  script  is  a  text  file  that has execute permission
>        enabled and whose first line is of the form:
>
>            #! interpreter [optional-arg]
>
>        The interpreter must be a valid pathname for an executable which is not
>        itself  a  script. 
> ------------------------------------------------------
>
> I.e, execve should return ENOEXEC. And it did it at least in Fedora 8 and earlier.
>
> To me it looks like  execve and it's man page disagree. Do you know is it new intended behaviour of execve and just man page wasn't update or it's a bug in execve ?

Code and man pages do sometimes disagree.  I shan't address what the 
correct behaviour is, because if you ask three people you're sure to get 
four different answers, rather let's discuss what is desirable.  Without 
looking at how it works, we observe that a.sh can be executed without 
error.  If a.out were written in C it would qualify as an acceptable 
interpreter according to the man page, so why should it not qualify if 
it is interpreted?  I think it's desirable that it does qualify.  There 
could be sound reasons why only one level of interpreter can be 
invoked.  Perhaps loading a script interpreter is done as an exception 
in exec, and it's too ugly to allow recursive exceptions.  That would be 
a fair reason.  But if there's no reason, then don't have the 
restriction*.  Linux now apparently does permit interpreted 
interpreters, and I say that is the desirable result.

*Newall's second rule of programming: A program should impose no 
unnecessary restriction on its user.
