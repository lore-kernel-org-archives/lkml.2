Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1LAARr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:17:47 -0500
Received: from ffm.saftware.de ([83.141.3.46]:39092 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab1LAARq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:17:46 -0500
X-Greylist: delayed 492 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Nov 2011 19:17:45 EST
Message-ID: <4ED6C5B8.8040803@linuxtv.org>
Date: Thu, 01 Dec 2011 01:09:28 +0100
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: HoP <jpetrous@gmail.com>
CC: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] vtunerc: virtual DVB device - is it ok to NACK driver because
 of worrying about possible misusage?
References: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
In-Reply-To: <CAJbz7-2T33c+2uTciEEnzRTaHF7yMW9aYKNiiLniH8dPUYKw_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.11.2011 22:38, HoP wrote:
> Hi folks.
> 
> I need to warn you that my mail is a bit little longer then I would like
> to be.But I'm not able to ask my question without some
> background information.
> 
> On June 19th, I was sending the driver to the Linux-media
> mailing list. Original announcement is there:
> 
> http://www.spinics.net/lists/linux-media/msg34240.html
> 
> One would say that the code describes very well what it does = adds
> virtual DVB device. To be more clear on it I have even done some
> small picture:
> 
> http://www.nessiedvb.org/wiki/doku.php?id=vtuner_bigpicture
> 
> I was hoping to get any feedback regarding code implementation.
> It was my first code for the kernel and I felt very well that some
> part can be done better or even simpler.
> 
> What really surprised me badly was that when I read all 54 responses
> I have counted only two real technical answers!!! All rest were about
> POLITICAL issues - code was NACKed w/o any technical discussion.
> Because of fear of possible abusing of driver.
> 
> I didn't know that there existed very big movement against such
> code in dvb-core subsystem before.
> 
> I have one big problem with it. I can even imagine that some "bad guys"
> could abuse virtual driver to use it for distribution close-source drivers
> in the binary blobs. But is it that - worrying about bad boys abusing -
> the sufficient reason for such aggressive NACK which I did? Then would
> be better to remove loadable module API fully from kernel. Is it the right way?
> 
> Please confirm me that worrying about abusive act is enough to NACK
> particular driver. Then I may be definitely understand I'm doing something
> wrong and will stay (with such enemy driver) out of tree.
> 
> I can't understand that because I see very similar drivers in kernel for ages
> (nbd, or even more similar is usbip) and seems they don't hamper to anybody.
> 
> I would like to note that I don't want to start any flame-war, so very short
> answer would be enough for me.,

Hello Honza,

I still support the inclusion of your virtual DVB device driver, once
the technical issues[1] are solved (design clean interface based on
DVBv5 etc.). Mauro promised to consider it for inclusion then[2]. A
quick view at your code indicates that this clean-up hasn't happened
yet, e.g. there are hacks to support DVB-S2 over DVBv3 which aren't
necessary anymore with v5.

Regarding the kernellabs.com people[3] lobbying against your
contribution: Don't give up! If all attempts of merging your work
through the media subsystem are failing, try convincing some major
distributions to include your work. This would make their arguments
meaningless. On the long run, good code is likely to win over politics.

Regards,
Andreas

[1] http://www.spinics.net/lists/linux-media/msg34349.html
[2] http://www.spinics.net/lists/linux-media/msg34352.html
[3] http://www.kernellabs.com/blog/?page_id=6
[4]
http://code.google.com/p/vtuner/source/browse/vtunerc_proxyfe.c?repo=linux-driver#177
