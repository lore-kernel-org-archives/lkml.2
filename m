Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0CTGmn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 02:42:43 -0400
Received: from web110305.mail.gq1.yahoo.com ([67.195.8.205]:38780 "HELO
	web110305.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752123Ab0CTGmm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 02:42:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=wQR9D3B/EEKtdmOB8/OLiG4lEE8QKdfJmotZ+FwRE1ziiCWbhv9Fv1C+J9jEplFSn7nBSlPA8yigx2CbC+O6g1vAFtk47/jYydKZwOPw7vcJ0B03EDSnzLd+1EGdHXlOfF/Xxr/BWN9zMa8tAI/o44cBLsVo017e1hpHOCULZHc=;
Message-ID: <687582.96058.qm@web110305.mail.gq1.yahoo.com>
X-YMail-OSG: JCyiOtUVM1k9f_XHOfggfSTNJrEwmfIUHqs2z1XIo7D.akL
 72ffQvK63UOAWgrA7KukH0X38VFTVitq3CFcMs_00UD1KWrAxzAmTFFN.Mea
 4uohlaKNqJZSceTxzswSXtuKnh5aVfydmsPRhiMjoqGiUckmwdYMvp9M4urB
 uT9gO.fHww5nNR8aqDLnRccxSG2YkpWiAE.ozWmnxngO59_68Ui1BszbzKBJ
 V_tX_TuzeS0_kq69XfDp2KRADUmu1X9BfXrCwyfy7DxhhoaL76ZDX6Cw1DvN
 9lfi.BgPSe2I44ciSZqXRY4dyVRQfTJjoS3zVk12bCyIyRnyeUs7f0ElO0Qg
 TqL4F.KNHr79rnz8SPD6UDPAt_WHVs5kyYQc-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Fri, 19 Mar 2010 23:42:41 -0700 (PDT)
From: Valery Reznic <valery_reznic@yahoo.com>
Subject: Re: execve for script don't return ENOEXEC, bug ?
To: David Newall <davidn@davidnewall.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4BA418B2.8090200@davidnewall.com>
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
> Date: Saturday, March 20, 2010, 2:37 AM
> On Thu, 11 Mar 2010 02:56:16 -0800
> (PST) Valery Reznic <valery_reznic@yahoo.com>
> wrote:
> > Hi,
> > 
> > I Have following to scripts:
> > 
> > a.sh
> > #!/bin/sh
> > echo "It's a.sh
> > 
> > and b.sh:
> > #! ./b.sh
> > echo "It's b.sh"
> >   
> [...]
> > When I run same scripts on Fedora 12 x86_64 box with
> stock kernel 2.6.31.5-127.fc12.x86_64 I got following:
> > 
> > strace -f -e execve setarch i386  ./b.sh
> execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"],
> [/* 41 vars */]) = 0
> > execve("./b.sh", ["./b.sh"], [/* 41 vars */]) = 0
> > It's a.sh
> 
> I see no circumstance which would make b.sh invoke a.sh
> (and thus emit "It's a.sh"). Are you sure these are the
> actual scripts and output?

Of course you are right. Somehow I messed up b.sh
(OK, this file is so long and complicated, so no wonder :)
Anyway my bad, sorry.

In the b.sh interpreter should be ./a.sh

Another attempt to provide correct data:

[valery@localhost ~]$ cat a.sh 
#!/bin/sh
echo "It's a.sh"
[valery@localhost ~]$ cat b.sh 
#! ./a.sh
echo "It's b.sh"
[valery@localhost ~]$ 
[valery@localhost ~]$ strace -f -e execve setarch i386 ./b.sh 
execve("/usr/bin/setarch", ["setarch", "i386", "./b.sh"], [/* 40 vars */]) = 0
execve("./b.sh", ["./b.sh"], [/* 40 vars */]) = 0
It's a.sh
[valery@localhost ~]$ 




> 
> On the other hand, if the output was "It's b.sh", this is
> compatible with many historical versions of UNIX, which
> assumed /bin/sh to be the script interpreter. On
> 2.6.28-16-generic #55-Ubuntu SMP i686 GNU/Linux I get
> successful output for the following variants of "x.sh":
> 
> :
> echo worked
> 
> and
> 
> #!
> echo worked
> 
> and
> 
> #! ./x.sh
> echo worked
My problem is not incorrect output, but successful execve, when script's interpreter is interpreter itself.

Somewhere between Fedora 8 and Fedora 12 execve's behaviour changed.

@Andrew:
When b.sh has interpreter ./b.sh I got expected ENOEXEC, same as you.

Regards,
Valery.

> 


      
