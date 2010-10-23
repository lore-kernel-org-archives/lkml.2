Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab0JWAy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 20:54:56 -0400
Received: from mail.wdtv.com ([66.118.69.84]:60735 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0JWAyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 20:54:55 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.36, make oldconfig broken
Date: Fri, 22 Oct 2010 20:54:51 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; i686; ; )
References: <201010221229.36996.gene.heskett@gmail.com> <201010221608.36754.gene.heskett@gmail.com> <4CC20011.5010809@oracle.com>
In-Reply-To: <4CC20011.5010809@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_cJjwMo9cJmck6ZV"
Message-Id: <201010222054.52066.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_cJjwMo9cJmck6ZV
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit

On Friday, October 22, 2010, Randy Dunlap wrote:
>On 10/22/10 13:08, Gene Heskett wrote:
>> On Friday, October 22, 2010, Randy Dunlap wrote:
>>> On Fri, 22 Oct 2010 12:29:36 -0400 Gene Heskett wrote:
>>> 
>>> [adding linux-kbuild]
>>> 
>>>> Greets all;
>>>> 
>>>> I have managed to get 2.6.36 to a semi-usable state, but I have major
>>>> breakage yet.
>>>> 
>>>> Question: what happens if I simply move my working 2.6.35.7 .config
>>>> into the 2.6.36 tree and build it from that?
>>> 
>>> I think that it runs 'make oldconfig' automatically for you.
>>> 
>>>> It can't be any worse than what the broken 'make oldconfig' did to
>>>> it. What it output changed the disk drivers, graphic card drivers
>>>> and just plain threw away at least a hundred lines in the multimedia
>>>> drivers section.
>
>When I use your config-2.6.36.7 file on 2.6.36 and run 'make oldconfig',
Correction, that config was from 2.6.35.7.

>I don't see anything like changes in disk or graphics card drivers and
>I don't see 100 or more lines thrown away in the multimedia drivers.
>
>Did you use 'make oldconfig' or did you use that script that you have
>mentioned and posted in the past?  Could it be causing problems?

My script (buildit26) takes an old argument and a new argument, that and 
any patch names needed are edited into it, not passed as arguments, 
although I have thought of doing that, but as that can lead to typu's 
getting past these old fingers, I don't trust me doing it with live 
arguments.  It copy's the old .configs to /tmp long enough to unpack the 
new, then copy's them into the new tree.  And they do a make oldconfig after 
any patches have been applied.

It hasn't been edited since I ran it, so I'll attach it.  Maybe you can see 
something I missed.

Thanks Randy.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
About the only thing on a farm that has an easy time is the dog.

--Boundary-00=_cJjwMo9cJmck6ZV
Content-Type: application/x-shellscript;
  name="buildit26"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="buildit26"

#!/bin/bash
# This is intended to allow a from scratch start of a known good
# set of configs based on the last full release.
# This is the src to get the known good configs from
VEROLD="linux-2.6.35.7"
# This is the src file to be used
VERSRC="linux-2.6.36"
NEWVERNUM="2.6.36"
VNAME="linux-"$NEWVERNUM
echo $VNAME
# These are the patchfile(s) to be used
VERP1="patch-"$NEWVERNUM
echo $VERP1
sleep 3
#VERP3=""
#VERP3=""
#VERP4=""
#VERP5=""
#VERP6=""
#VERP7=""
#VERP8=""
#VERP9=""
#echo $VERP1
#echo $VERP2
#echo $VERP3
#echo $VERP3
#echo $VERP4
#echo $VERP5
#echo $VERP6
#echo $VERP7
#echo $VERP8
#echo $VERP9
# and this is what to name it
echo "if above isn't correct hit ctl-c"
sleep 5
# get to it
echo
pwd
echo $VEROLD
sleep 1
cd $VEROLD
pwd
sleep 1
echo copying older configs to safe place
cp -f .config /var/.config26
cp -f .config.old /var/.config.old26
cp -f makeit /var/makeit26
# back out
cd ..
echo the next line should be usr src
pwd
echo
sleep 1
echo mv unpatched kernel tree out of the way
echo moveing $VERSRC to $VERSRC.keep
echo this will remove an existing one!
sleep 5 #time to hit ctl-c
echo timeout  -  doing it
touch $VERSRC #in case it doesn't exist
mv $VERSRC $VERSRC.keep
echo
ls -l $VERSRC.keep #see what it was?
sleep 1
echo unpacking a fresh copy of the base version from scratch
echo
#tar xjf $VERSRC.tar.bz2
rm -fR $VNAME #blow it away if it exists
tar xzf $VERSRC.tar.gz
echo
#echo "unpacking the patch(es)"
#gunzip $VERP1.gz
#gunzip $VERP2.gz
#gunzip $VERP3.gz
# add more as required
echo
echo done.
mv $VERSRC $VNAME
echo
ls -l $VNAME
sleep 1
echo restoreing original srcs
mv $VERSRC.keep $VERSRC
echo
cd $VNAME
pwd
#sleep 1
 COPY the firmware/radeon stuff over
mkdir firmware/radeon
## did it make it?
echo firmware contents
ls firmware
echo
echo 'firmware/radeon contents'
ls firmware/radeon
echo
echo make sure the old one is there
ls ../$VEROLD/firmware/radeon
echo now copy it
cp -f ../$VEROLD/firmware/radeon/* ./firmware/radeon/
echo
echo was the copy good
ls firmware/radeon
# apply the patches
echo
#echo Applying patch $VERP1
#echo
#sleep 1
#patch -p1 <"../"$VERP1
#echo
#echo patch $VERP1 done
#echo now applying $VERP2
#sleep 1
#echo
#patch -p1 <"../"$VERP2
#sleep 1
#echo
#echo patch $VERP2 done
#echo
#echo - now applying $VERP3
#sleep 2
#patch -p1 <"../"$VERP3
#sleep 2
#echo
#echo done - now applying $VERP4
#sleep 2
#echo
#patch -p1 <$VERP4
#sleep 2
#echo
#echo done - now applying $VERP5
#sleep 2
#echo
#patch -p1 <$VERP5
#sleep 2
#echo
#echo done - now applying $VERP6.
#sleep 2
#echo
#patch -p1 <$VERP6
#sleep 2
#echo done - now applying $VERP7
#sleep 2
#patch -p1 <$VERP7
#echo done - now applying $VERP8
#sleep 2
#patch -p1 <$VERP8
#echo done - now applyng patch $VERP9
#sleep 2
#patch -p1 <$VERP9
echo done
# suggested by Marcelo
cp /var/.config26 .config
cp /var/.config.old26 .config.old
cp /var/makeit26 makeit
make oldconfig
make mrproper
make xconfig
#make menuconfig

--Boundary-00=_cJjwMo9cJmck6ZV--
