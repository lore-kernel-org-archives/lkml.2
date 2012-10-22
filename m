Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337Ab2JVVya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 17:54:30 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5761 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab2JVVy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 17:54:28 -0400
X-Authority-Analysis: v=2.0 cv=GZOVbHrL c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=0N38pj-gRz4A:10 a=glBvsuNLT8EA:10 a=05ChyHeVI94A:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=9H2X1eDI008A:10 a=rfgCSFRqbchW9Un1Em0A:9 a=QEXdDO2ut3YA:10 a=A2_f8oNBP7p6PkC3:21 a=dWRCleyyi1xqq0iG:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <5085C092.8020309@cfl.rr.com>
Date: Mon, 22 Oct 2012 17:54:26 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: markh@compro.net
CC: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] drm_kms_helper problems
References: <508409FC.6080805@cfl.rr.com> <20121021165802.578d6d6b@neptune.home> <50843C83.8040801@cfl.rr.com> <20121021211817.58c6ccaf@neptune.home> <50853121.3040803@cfl.rr.com> <50858513.3070909@compro.net>
In-Reply-To: <50858513.3070909@compro.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruno,

On 10/22/2012 01:40 PM, Mark Hounschell wrote:
> On 10/22/2012 07:42 AM, Mark Hounschell wrote:
>> On 10/21/2012 03:18 PM, Bruno Prémont wrote:
>>> Hi Mark,
>>>
>>> On Sun, 21 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>>>> On 10/21/2012 10:58 AM, Bruno Prémont wrote:
>>>>> On Sun, 21 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>>>>>> I have a TV that appears to not provide proper EDID info to the HDMI
>>>>>> or DVI
>>>>>> ports of my Intel DH77DF motherboard. I received some pointers from this
>>>>>> list that pointed me in the direction of creating my own EDID file and I
>>>>>> now have a binary blob that matches what the service manual says is the
>>>>>> proper EDID info.
>>>>>>
>>>>>> But I am unable to get the drm_kms_helper module to load and use this
>>>>>> file.
>>>>>> My relevant kernel config options are.
>>>>>>
>>>>>> CONFIG_DRM_KMS_HELPER=m
>>>>>> CONFIG_DRM_LOAD_EDID_FIRMWARE=y
>>>>>>
>>>>>> my relevant kernel command line contains:
>>>>>>
>>>>>> video=card0-HDMI-A-1:e
>>>>>> drm_kms_helper.edid_firmware=card0-HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>>>>
>>>>> The variant without card0- should be the right one.
>>>>>
>>>>
>>>> OK. Changed it. What if I had more than one video card?
>>>
>>> Two connectors from two distinct card should not get the same suffix number
>>> even if they use same technology, so it should work. (unless something was
>>> changed recently)
>>>
>>>>>> The edid file:
>>>>>> # ls -al /lib/firmware/edid/lg42lb9df_hdmi1.edid
>>>>>> -rw-r--r-- 1 root root 256 Oct 16 05:46
>>>>>> /lib/firmware/edid/lg42lb9df_hdmi1.edid
>>>>>>
>>>>>> connector info from /sys/class/drm/
>>>>>>
>>>>>> card0  card0-DP-1  card0-DP-2  card0-DP-3  card0-HDMI-A-1 card0-HDMI-A-2
>>>>>> card0-HDMI-A-3  card0-VGA-1  controlD64  version
>>>>>>
>>>>
>>>> Which should I use? HDMI-A-1, HDMI-A-2, or  HDMI-A-3? Why re there 3??
>>>>
>>>>>> And I don't really understand why I have 3 entries for the one hdmi
>>>>>> port?
>>>>>> Nor do I really understand _exactly_ how to define the connector in my
>>>>>> kernel command line or which of the 3 connectors from /sys I should be
>>>>>> using. I've tried different variants. Ie. card0-HDMI-A-1and HDMI-A-1.
>>>>>>
>>>>>> The results in the kernel log file remain:
>>>>>>
>>>>>> [    1.879654] drm_kms_helper: Unknown parameter `edid'
>>>>>
>>>>> As your drm_kms_helper is built modular, did you try not putting that
>>>>> parameter on kernel cmdline but rather put it in modprobe's configuration
>>>>> for that module? (may doing the whole loading manually).
>>>>>
>>>>
>>>> I've created a /etc/modprobe.d/20-drm_kms_helper.conf with:
>>>> options drm_kms_helper edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>>> and now I'm getting something different. It looks like it's trying. In
>>>> fact
>>>> I actually get a screen on the TV now. It's not 1920x1080 but 1024x768 at
>>>> 60hz.
>>>
>>> As things get slightly better now, check what kernel detected:
>>> - /sys/module/drm_kms_helper/parameters/edid_firmware
>>>    (should contain the path to firmware file)
>>>
>>> Make sure both the firmware and modprobe config get included in your initrd
>>> if you're using one.
>>>
>>>> [    1.883124] load_module: Calling parse_args for module = drm_kms_helper
>>>> args = edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>>> [    1.883126]
>>>> [    1.883126] parse_args: (1) Entered for drm_kms_helper
>>>> [    1.883127]
>>>> [    1.883127] parse_args: (2) Entered for drm_kms_helper
>>>> [    1.883127] parse_args: doing = drm_kms_helper
>>>> [    1.883128] parse_args: args  =
>>>> edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>>> F\xffffffc9\xfffffff8h\xffffff89\xffffff86\xffffffc0\xffffff80\xffffffff\xffffffff\xffffffd4R\xffffffc9\xfffffff8TF\xffffffc9\xfffffff88\xffffff89\xffffff86\xffffffc0\xffffffa4\xffffffff\xffffffffdF\xffffffc9\xfffffff8
>>>>
>>>> [    1.883129] parse_args: num = 2
>>>> [    1.883130] parse_args: min_level = -32768
>>>> [    1.883131] parse_args: max_level = 32767
>>>> [    1.883132]
>>>> F\xffffffc9\xfffffff8h\xffffff89\xffffff86\xffffffc0\xffffff80\xffffffff\xffffffff\xffffffd4R\xffffffc9\xfffffff8TF\xffffffc9\xfffffff88\xffffff89\xffffff86\xffffffc0\xffffffa4\xffffffff\xffffffffdF\xffffffc9\xfffffff8,
>>>>
>>>> num=2, min_level=-32768, max_level=32767
>>>> [    1.886855]
>>>> .
>>>> .
>>>> .
>>>> [    2.132749] [drm] forcing HDMI-A-1 connector ON
>>>> [    2.132752] [drm] forcing HDMI-A-2 connector ON
>>>> [    2.132753] [drm] forcing HDMI-A-3 connector ON
>>>>
>>>> [    2.189769] [drm:edid_load] *ERROR* Requesting EDID firmware
>>>> "edid/lg42lb9df_hdmi1.edid" failed (err=-2)
>>>
>>> Interesting, kernel/udev can't find the edid file but know what file
>>> to look for... Is the edid file available at that time (initrd?)?
>>>
>>>> I get a couple of the above messages.
>>>>
>>>>
>>>> [    2.388623] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
>>>> invalid,
>>>> remainder is 130
>>>> [    2.388631] Raw EDID:
>>>> [    2.388635]          00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
>>>
>>> That's as ago with getting edid from hardware.
>>>
>>>>> # modprobe drm_kms_helper
>>>>> edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>>>>
>>>>
>>>> I can't seem to rm the modules already loaded to try this.
>>>
>>> There are multiple steps needed to be able to rmmod those modules:
>>> - stop DRM users (e.g. X)
>>> - disable fbcon
>>>    echo 1 > /sys/class/vtcon0/bind
>>>    echo 0 > /sys/class/vtcon1/bind
>>>    (assuming vtcon1 is fbcon, vtcon0 is VGA console)
>>> - rmmod i915
>>> - rmmod drm_kms_helper
>>>
>>> Note that at time of modprobing i915 connectors will have different names!
>>> (probably HDMI-A-4, HDMI-A-5, HDMI-A-6)
>>>
>>> Alternatively you could blacklist all drm modules so they don't get loaded
>>> automatically and you can load them manually one at a time when system has
>>> booted.
>>>
>>
>> It turns out the boot params "video=HDMI-A-1:e video=HDMI-A-2:e
>> video=HDMI-A-3:e" are what actually turned the tv "on". They seem to
>> default to "d". In any case I now have only that in my grub file except
>> for the "video=1024x768" and I'm not really sure what that actually does.
>>
>> My /etc/modprobe.d/20-drm_kms_helper.conf contains:
>> options drm_kms_helper edid_firmware=HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>
>> How can I add the other connector info to that file BTW?
>>
>> It now looks like it is finding the edid file.
>>  # cat /sys/module/drm_kms_helper/parameters/edid_firmware
>> HDMI-A-1:edid/lg42lb9df_hdmi1.edid
>>
>> What I End up with is a 1024x768 on both the DVI and HDMI port outputs
>> and then every 5-10 seconds the below gets spewed to the log file and the
>> system is unresponsive while this occures. I don't understand why this
>> messes up the DVI port. With no 20-drm_kms_helper.conf file the DVI port
>> get 1600x1200
>>
>> geexbox:/home/markh # tail -f /var/log/messages
>> Oct 22 03:25:12 geexbox kernel: [  174.716622]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716623]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716625]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716626]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716628]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716629]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716639]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716640]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:12 geexbox kernel: [  174.716642] i915 0000:00:02.0:
>> HDMI-A-3: EDID block 0 invalid.
>> Oct 22 03:25:13 geexbox su: (to root) markh on /dev/pts/0
>> Oct 22 03:25:21 geexbox kernel: [  183.760787] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:21 geexbox kernel: [  183.760791] Raw EDID:
>> Oct 22 03:25:21 geexbox kernel: [  183.760794]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760795]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760797]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760798]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760800]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760801]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760802]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.760804]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873788] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:21 geexbox kernel: [  183.873791] Raw EDID:
>> Oct 22 03:25:21 geexbox kernel: [  183.873793]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873795]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873796]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873798]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873799]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873800]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873802]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:21 geexbox kernel: [  183.873803]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986796] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:22 geexbox kernel: [  183.986799] Raw EDID:
>> Oct 22 03:25:22 geexbox kernel: [  183.986801]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986802]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986804]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986805]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986807]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986808]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986810]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  183.986811]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099814] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:22 geexbox kernel: [  184.099817] Raw EDID:
>> Oct 22 03:25:22 geexbox kernel: [  184.099819]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099821]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099822]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099824]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099825]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099826]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099828]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099829]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.099841] i915 0000:00:02.0:
>> HDMI-A-3: EDID block 0 invalid.
>> Oct 22 03:25:22 geexbox kernel: [  184.331124] [drm] Got external EDID
>> base block and 1 extension from "edid/lg42lb9df_hdmi1.edid" for connector
>> "HDMI-A-1"
>> Oct 22 03:25:22 geexbox kernel: [  184.462110] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:22 geexbox kernel: [  184.462113] Raw EDID:
>> Oct 22 03:25:22 geexbox kernel: [  184.462115]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462117]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462118]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462120]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462121]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462122]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462124]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.462134]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575122] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:22 geexbox kernel: [  184.575125] Raw EDID:
>> Oct 22 03:25:22 geexbox kernel: [  184.575127]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575128]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575130]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575131]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575133]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575142]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575143]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.575143]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688133] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:22 geexbox kernel: [  184.688136] Raw EDID:
>> Oct 22 03:25:22 geexbox kernel: [  184.688138]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688140]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688141]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688143]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688144]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688145]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688147]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.688148]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801139] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:22 geexbox kernel: [  184.801142] Raw EDID:
>> Oct 22 03:25:22 geexbox kernel: [  184.801144]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801145]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801147]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801148]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801150]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801151]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801152]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801162]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:22 geexbox kernel: [  184.801164] i915 0000:00:02.0:
>> HDMI-A-3: EDID block 0 invalid.
>> Oct 22 03:25:23 geexbox kernel: [  185.017189] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:23 geexbox kernel: [  185.017192] Raw EDID:
>> Oct 22 03:25:23 geexbox kernel: [  185.017194]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017196]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017197]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017199]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017200]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017202]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017203]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.017204]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130197] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:23 geexbox kernel: [  185.130200] Raw EDID:
>> Oct 22 03:25:23 geexbox kernel: [  185.130202]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130204]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130205]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130206]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130208]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130209]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130211]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.130212]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243209] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:23 geexbox kernel: [  185.243212] Raw EDID:
>> Oct 22 03:25:23 geexbox kernel: [  185.243214]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243216]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243217]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243218]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243220]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243221]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243223]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.243224]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356218] [drm:drm_edid_block_valid]
>> *ERROR* EDID checksum is invalid, remainder is 130
>> Oct 22 03:25:23 geexbox kernel: [  185.356221] Raw EDID:
>> Oct 22 03:25:23 geexbox kernel: [  185.356223]          00 ff ff ff ff ff
>> ff 00 ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356224]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356226]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356227]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356228]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356230]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356231]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356233]          ff ff ff ff ff ff
>> ff ff ff ff ff ff ff ff ff ff
>> Oct 22 03:25:23 geexbox kernel: [  185.356245] i915 0000:00:02.0:
>> HDMI-A-3: EDID block 0 invalid.
>>
>> Should I maybe add the info for the other connectrs to the modprobe file?
>> If so what would be the syntax?
>>
>> dmesg attached
>
> One thing I forgot to mention is that I do have the edid file built into
> the kernel via:
> CONFIG_EXTRA_FIRMWARE="edid/lg42lb9df_hdmi1.edid"

Another interesting thing. I changed the boot file to only 
"video=HDMI-A-1:e" and the monitor on the DVI port complains about the 
resolution being to high. I then put the hdmi cable onto my dvi/hdmi 
adapter and plug it into the DVI port and wala, a 1920 x 1080 desktop. So I 
reboot with it in that configuration  and again comes up good connected to 
the DVI connector.

# xrandr
Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
VGA1 disconnected (normal left inverted right x axis y axis)
HDMI1 connected 1920x1080+0+0 (normal left inverted right x axis y axis) 
708mm x 398mm
    1920x1080      60.0*+   50.0     25.0     30.0     30.0     24.0
    1680x1050      59.9
    1680x945       60.0
    1400x1050      59.9
    1600x900       60.0
    1280x1024      75.0     60.0
    1440x900       59.9
    1280x960       60.0
    1366x768       60.0
    1360x768       60.0
    1280x800       74.9     59.9
    1152x864       75.0
    1280x768       74.9     60.0
    1280x720       50.0     60.0
    1024x768       75.1     70.1     60.0
    1024x576       60.0
    800x600        72.2     75.0     60.3     56.2
    720x576        50.0
    848x480        60.0
    720x480        59.9
    640x480        72.8     75.0     60.0     59.9     59.9
    720x400        70.1
DP1 disconnected (normal left inverted right x axis y axis)
HDMI2 disconnected (normal left inverted right x axis y axis)
HDMI3 disconnected (normal left inverted right x axis y axis)
DP2 disconnected (normal left inverted right x axis y axis)
DP3 disconnected (normal left inverted right x axis y axis)

I'm still getting the same messages spewed into the kernel log file. So 
this looks to me like the kernel is confused. Again, I ask, why do I have 3 
HDMIs and 3 DPs but just one VGA.

Something is just not right here. I'm beginning to think it's not me.

Mark

