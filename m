Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1FIXc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 19:32:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab1FIXc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 19:32:56 -0400
Message-ID: <4DF1581E.8050308@redhat.com>
Date: Thu, 09 Jun 2011 20:32:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 8 (docbook/media)
References: <20110608161046.4ad95776.sfr@canb.auug.org.au> <20110608125243.e63a07fc.randy.dunlap@oracle.com> <4DF11E15.5030907@infradead.org> <4DF12263.3070900@redhat.com> <4DF12DD1.7060606@oracle.com>
In-Reply-To: <4DF12DD1.7060606@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 09-06-2011 17:32, Randy Dunlap escreveu:
> On 06/09/11 12:43, Mauro Carvalho Chehab wrote:
>> Em 09-06-2011 16:25, Mauro Carvalho Chehab escreveu:
>>> Em 08-06-2011 16:52, Randy Dunlap escreveu:
>>>> The DocBook/media/Makefile seems to be causing too much noise:
>>>>
>>>> ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.gif: No such file or directory
>>>> ls: cannot access linux-next-20110608/Documentation/DocBook/media/*/*.png: No such file or directory
>>>>
>>>> Maybe the cleanmediadocs target could be made silent?
>>>
>>> I'll take a look on it. 
>>>
>>> FYI, The next build will probably be noisier, as it is now pointing to some 
>>> documentation gaps at the DVB API. Those gaps should take a longer time to fix, 
>>> as we need to discuss upstream about what should be done with those API's,
>>> that seems to be abandoned upstream (only one legacy DVB driver uses them).
>>> However, I was told that some out-of-tree drivers and some drivers under development
>>> are using them.
>>>
>>> So, I intend to wait until the next merge window before either dropping those 
>>> legacy API specs (or moving them to a deprecated section) or to merge those
>>> out-of-tree drivers, with the proper documentation updates.
>>>
>>>> also, where is the mediaindexdocs target defined?
>>>
>>> Thanks for noticing it. We don't need this target anymore. I'll write a patch
>>> removing it.
>>
>> This patch should remove the undesired noise.
> 
> 
> Doesn't work for me.  Did you test it?

Yes:

$ make htmldocs
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//v4l2.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//media-entities.tmpl
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//media-indices.tmpl
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//videodev2.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//audio.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//ca.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//dmx.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//frontend.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//net.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//video.h.xml
  DOCPROC Documentation/DocBook/media_api.xml
  HTML    Documentation/DocBook/media_api.html
Error: no ID for constraint linkend: AUDIO_GET_PTS.
Error: no ID for constraint linkend: AUDIO_BILINGUAL_CHANNEL_SELECT.
Error: no ID for constraint linkend: CA_RESET.
Error: no ID for constraint linkend: CA_GET_CAP.
Error: no ID for constraint linkend: CA_GET_SLOT_INFO.
Error: no ID for constraint linkend: CA_GET_DESCR_INFO.
Error: no ID for constraint linkend: CA_GET_MSG.
Error: no ID for constraint linkend: CA_SEND_MSG.
Error: no ID for constraint linkend: CA_SET_DESCR.
Error: no ID for constraint linkend: CA_SET_PID.
Error: no ID for constraint linkend: DMX_GET_PES_PIDS.
Error: no ID for constraint linkend: DMX_GET_CAPS.
Error: no ID for constraint linkend: DMX_SET_SOURCE.
Error: no ID for constraint linkend: DMX_ADD_PID.
Error: no ID for constraint linkend: DMX_REMOVE_PID.
Error: no ID for constraint linkend: NET_ADD_IF.
Error: no ID for constraint linkend: NET_REMOVE_IF.
Error: no ID for constraint linkend: NET_GET_IF.
Error: no ID for constraint linkend: VIDEO_GET_SIZE.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_RATE.
Error: no ID for constraint linkend: VIDEO_GET_PTS.
Error: no ID for constraint linkend: VIDEO_GET_FRAME_COUNT.
Error: no ID for constraint linkend: VIDEO_COMMAND.
Error: no ID for constraint linkend: VIDEO_TRY_COMMAND.
rm -rf Documentation/DocBook/index.html; echo '<h1>Linux Kernel HTML Documentation</h1>' >> Documentation/DocBook/index.html && echo '<h2>Kernel Version: 3.0.0-rc1</h2>' >> Documentation/DocBook/index.html && cat Documentation/DocBook/80211.html Documentation/DocBook/alsa-driver-api.html Documentation/DocBook/debugobjects.html Documentation/DocBook/device-drivers.html Documentation/DocBook/deviceiobook.html Documentation/DocBook/drm.html Documentation/DocBook/filesystems.html Documentation/DocBook/gadget.html Documentation/DocBook/genericirq.html Documentation/DocBook/kernel-api.html Documentation/DocBook/kernel-hacking.html Documentation/DocBook/kernel-locking.html Documentation/DocBook/kgdb.html Documentation/DocBook/libata.html Documentation/DocBook/librs.html Documentation/DocBook/lsm.html Documentation/DocBook/mcabook.html Documentation/DocBook/media_api.html Documentation/DocBook/mtdnand.html Documentation/DocBook/networking.html Documentation/DocBook/rapidio.html Docum
entation/DocBook/regulator.html Documentation/DocBook/s390-drivers.html Documentation/DocBook/scsi.html Documentation/DocBook/sh.html Documentation/DocBook/tracepoint.html Documentation/DocBook/uio-howto.html Documentation/DocBook/usb.html Documentation/DocBook/writing-an-alsa-driver.html Documentation/DocBook/writing_usb_driver.html Documentation/DocBook/z8530book.html >> Documentation/DocBook/index.html
v4l@pedra ~/v4l/patchwork $ make cleandocs
make[1]: [cleanmediadocs] Erro 1 (ignorado)
v4l@pedra ~/v4l/patchwork $ make cleanmediadocs
make[1]: [cleanmediadocs] Erro 1 (ignorado)

(the above linkend errors are due to the lack of documentation for those ioctls, as I've
explained before).

> 
> Even this does not silence the noise for me:
> 
> cleanmediadocs:
> 	-@rm `find $(MEDIA_OBJ_DIR) -type l` $(GENFILES) $(IMGFILES) >/dev/null 2>&1

Weird.
The errors should be doing to stderr, so 2>/dev/null should be working.

Mauro
