Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab1BGD7t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 22:59:49 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:50921 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab1BGD7r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 22:59:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Omf+fAUDbWckvMVQut3FApIbV7Yolj52OXrDfo0D90/z7R+NZDXBiug9T6CXGtAo8i
         Kh6K1s6jB5qg7KQs22X1KDyXxN1hG4ypGXdslJhBWB7sj1neM5xqj++9r6hMQ8g9DmjR
         vIXFQMEjalB1bP19HNlkVRi0pCZmPZyPlWoJ0=
MIME-Version: 1.0
In-Reply-To: <4D4F1A3D.2090107@hardwarefreak.com>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
 <20110205214550.3cb0f0d1@galadriel2.home> <alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
 <20110205220621.GB17347@gallifrey> <alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
 <alpine.DEB.2.00.1102051753100.8518@p34.internal.lan> <4D4DE34E.7010308@hardwarefreak.com>
 <alpine.DEB.2.00.1102051958370.28109@p34.internal.lan> <4D4E127D.3060105@hardwarefreak.com>
 <alpine.DEB.2.00.1102060515230.28109@p34.internal.lan> <4D4F1A3D.2090107@hardwarefreak.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 7 Feb 2011 14:59:26 +1100
Message-ID: <AANLkTim8Qt25C+L+R3e-R2qW0K6XxQBv-Fsy8K=aVA2H@mail.gmail.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        Emmanuel Florac <eflorac@intellique.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-net@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 7, 2011 at 09:01, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Justin Piszcz put forth on 2/6/2011 4:16 AM:
>
>> Workflow process-
>>
>> Migrate data from old/legacy RAID sets to new ones, possibly also 2TB->3TB, so
>> the faster the transfer speed, the better.
>
> This type of data migration is probably going to include many many files of
> various sizes from small to large.  You have optimized your system performance
> only for individual large file xfers.  Thus, when you go to copy directories
> containing hundreds or thousands of files of various sizes, you will likely see
> much lower throughput using a single copy stream.  Thus if you want to keep that
> 10 GbE pipe full, you'll likely need to run multiple copies in parallel, one per
> large parent directory.  Or, run a single copy from say, 10 legacy systems to
> one new system simultaneously, etc.
>
> Given this situation, you may want to consider tar'ing up entire directories
> with gz or bz compression, if you have enough free space on the legacy machines,
> and copying the tarballs to the new system.  This will maximize your throughput,
> although I don't know if it will decrease your total work flow completion time,
> which should really be your overall goal.

Another option might be to use tar and gzip to bundle the data up,
then pipe it through netcat or ssh. When I have to transfer large
chunks of data I find this is the fastest method. That said, if the
connection is interrupted, then you're on your own. rsync might also
be a good option.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
