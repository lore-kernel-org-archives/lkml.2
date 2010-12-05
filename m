Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0LEIEj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 03:04:39 -0500
Received: from web53305.mail.re2.yahoo.com ([206.190.49.95]:21067 "HELO
	web53305.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753961Ab0LEIEi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 03:04:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gbuExJu8aCO7HbL3/mLW2sLV/aKjmsnJ5d1sdmmfNxwqY8xQ8UPCf+Fu/VRywZ4sgQEZQefQoLz2dpKWXsOIzJ2hE1zX/H836OMOerimBmg6e1f/AincgFmRmvpRXy1OvSM5My9Up2UxLx21G/AzDJ3vfUt09A6z/TSSMt6Vw/k=;
Message-ID: <270554.37369.qm@web53305.mail.re2.yahoo.com>
X-YMail-OSG: gaKuUSkVM1krF9tDXQS7DCQVlLUElJXQoQ7uZlyOfGC6Qgx
 DhtEoKMtMc9Gen2DKzvfS5xjV3_8pTLNo1rfuTXjFg0s8jrn0l.y4iIMdJ6T
 5WFts9wZJOsqwHvkTVvgJKa6lLrtiuS3MBU4Jqn5dx5Q8euFzByO7TWoYyU3
 ViA4k28k9Xw1fDbmAitpptQdd9dBOfq0.fCELvglXpgfqSgGkacKioqHhWNi
 9t9ac.vojDmWFOvGT2Rb07FNfUet9i_qFT979gzfaEl3yz20Ye5reb9ZDPq0
 TJK0g2wVp1.oFy2X2d1Nz4cnieqaRMZAs8LJsoIRZNMMsOUnANsawvTuCGl7
 N9pZBIg--
X-Mailer: YahooMailRC/553 YahooMailWebService/0.8.107.285259
Date: Sun, 5 Dec 2010 00:04:37 -0800 (PST)
From: Tal Lubko <tallubko@yahoo.com>
Subject: kgdb issues in 2.6.26.5-rt9
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am running a custom 2.6.26.5-rt9 kernel which is the 2.6.26.5 vanilla kernel 
with version 9 of the real time patch for that specific version. I am trying to 
debug a "hard" problem which means not a problem which is easily reproducibe, 
appears only on boot, only under certain conditions etc. In order to debug the 
problem I am using kgdb.

Before anyone flames me, I am aware that kgdb is not the highway as far as 
kernel debugging is concerned, but due to certain external factors I am 
interested in making that approach work.

My understanding of the kgdb status (please correct me if I am wrong on any of 
the following...):
- kgdb is supported in 2.6.26.5 vanilla and the important stuff works.
- the version of kgdb in 2.6.26.5 is the "light" version by Ingo, Thomas and 
Jason which means that some features are missing.
- I am not aware of any limitations of the host side gdb that I am supposed to 
use in order to debug the target (I tried using 6.6 and 6.8)

The problems I have with kgdb:
- info threads shows most of the threads on the system but then hangs for a 
short time with various data errors. As a first stab this seems like a protocol 
issue between host and target.
- thread [tid] does not work. It claims that the thread ids that I use do not 
exist although the info that I do manage to get out of "info threads" admits 
that they do. ps(1) on the target also confirms the thread id numbers.
- I haven't managed to set breakpoints. For instance: breaking on printk using 
"break printk" results in a segv of the debugger (huh?!?). This looks like a gdb 

protocol issue between the host and target which brings me back to the issue of 
whether there are limitations on the version of gdb to be used.

Please CC me on any replies since I am not subscribed.

Thanks in advance,
Tal



      
