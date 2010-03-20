Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0CTM4L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 08:56:11 -0400
Received: from web110306.mail.gq1.yahoo.com ([67.195.8.206]:29233 "HELO
	web110306.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752495Ab0CTM4J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 08:56:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=H5PrHmQdLAlcll36LrvFY8ptAqDxfXsMY6XqUlMOCv/x6TNNJ2ddVXYDbPhgBjLFBliXTuGz+VaqZPH1p+P7YuTKbYkAbNHdTmV8KUPAu4hKfxo6tZD2AMvy/iAOdx35xLJptEasQpvcjl5nLAbVpo3hF17v5ygedKxpWno4CqI=;
Message-ID: <435973.80037.qm@web110306.mail.gq1.yahoo.com>
X-YMail-OSG: oLKFOCQVM1kxwArJJN.Iw4DDmQRRcfInRckYEPWOctF9FxB
 OSc534yNYGtUC8olHrpRZ4PQ_M.6XIZOOQT6fVzw2cS1l9OScTe1kfaioBQh
 2v5XCgztEFopLRkbYMeuDD.trUEazUWqJJb2GrkKlnwPJqLXkMxJgb_h4oOu
 bgqGf8In6vxtyqQRIBfFJAkj5RWGWgdDffT3_RH5C5ZWmRDYMC34WCojP4MZ
 yAZM4WURYIrYsIBGyXm6ECzOHFJ8tixg9NKZfJqCDmazZcfLLaZ0k8..APjp
 Oo4MevibLunc1w7nW5lKjb.9xj92kAtul5Pw5ZR.rwB.FNxv8UTo9i7_PO7Q
 k87TgKRjvL7j9noGgJRapxQ--
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Sat, 20 Mar 2010 05:56:06 -0700 (PDT)
From: Valery Reznic <valery_reznic@yahoo.com>
Subject: Re: execve for script don't return ENOEXEC, bug ?
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4BA49864.7080503@davidnewall.com>
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
> Date: Saturday, March 20, 2010, 11:41 AM
> Valery Reznic wrote:
> > [valery@localhost ~]$ cat a.sh #!/bin/sh
> > echo "It's a.sh"
> > [valery@localhost ~]$ cat b.sh #! ./a.sh
> > echo "It's b.sh"
> > [valery@localhost ~]$ [valery@localhost ~]$ strace -f
> -e execve setarch i386 ./b.sh execve("/usr/bin/setarch",
> ["setarch", "i386", "./b.sh"], [/* 40 vars */]) = 0
> > execve("./b.sh", ["./b.sh"], [/* 40 vars */]) = 0
> > It's a.sh
> >   
> 
> That is the correct output for a script which is being
> interpreted by a.sh, when a.sh prints "It's a.sh" using
> /bin/sh as its interpreter.  Remember, you didn't ask
> /bin/sh to interpret b.sh, you asked a.sh to do it, and a.sh
> is a simple echo statement, not an interpreter.  There
> is no error here.

execve's man page state that script's interprtert should not be 
interpreter itself:
------------------------------------------------------
   Interpreter scripts
       An  interpreter  script  is  a  text  file  that has execute permission
       enabled and whose first line is of the form:

           #! interpreter [optional-arg]

       The interpreter must be a valid pathname for an executable which is not
       itself  a  script. 
------------------------------------------------------

I.e, execve should return ENOEXEC. And it did it at least in Fedora 8 and earlier.

To me it looks like  execve and it's man page disagree. Do you know is it new intended behaviour of execve and just man page wasn't update or it's a bug in execve ?

Valery.
> 


      
