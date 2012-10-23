Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932906Ab2JWJ77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 05:59:59 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:24862 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2JWJ76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 05:59:58 -0400
X-Authority-Analysis: v=2.0 cv=Q6tQEvKa c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=0N38pj-gRz4A:10 a=glBvsuNLT8EA:10 a=05ChyHeVI94A:10 a=8nJEP1OIZ-IA:10 a=ayC55rCoAAAA:8 a=9H2X1eDI008A:10 a=1JbS-s2C-jsue1JZQisA:9 a=wPNLvfGTeEIA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <50866A9C.5060507@cfl.rr.com>
Date: Tue, 23 Oct 2012 05:59:56 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] drm_kms_helper problems
References: <508409FC.6080805@cfl.rr.com> <20121021165802.578d6d6b@neptune.home> <50843C83.8040801@cfl.rr.com> <20121021211817.58c6ccaf@neptune.home> <50853121.3040803@cfl.rr.com> <50858513.3070909@compro.net> <5085C092.8020309@cfl.rr.com> <20121023083623.774f093e@pluto.restena.lu>
In-Reply-To: <20121023083623.774f093e@pluto.restena.lu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 02:36 AM, Bruno Prémont wrote:
> On Mon, 22 Oct 2012 17:54:26 Mark Hounschell wrote:
>> Another interesting thing. I changed the boot file to only
>> "video=HDMI-A-1:e" and the monitor on the DVI port complains about the
>> resolution being to high. I then put the hdmi cable onto my dvi/hdmi
>> adapter and plug it into the DVI port and wala, a 1920 x 1080 desktop. So I
>> reboot with it in that configuration  and again comes up good connected to
>> the DVI connector.
>
> So at least the EDID firmware now gets recognized and considered :)
>
>> # xrandr
>> Screen 0: minimum 320 x 200, current 1920 x 1080, maximum 8192 x 8192
>> VGA1 disconnected (normal left inverted right x axis y axis)
>> HDMI1 connected 1920x1080+0+0 (normal left inverted right x axis y axis)
>> 708mm x 398mm
>>      1920x1080      60.0*+   50.0     25.0     30.0     30.0     24.0
>>      1680x1050      59.9
>>      1680x945       60.0
>>      1400x1050      59.9
>>      1600x900       60.0
>>      1280x1024      75.0     60.0
>>      1440x900       59.9
>>      1280x960       60.0
>>      1366x768       60.0
>>      1360x768       60.0
>>      1280x800       74.9     59.9
>>      1152x864       75.0
>>      1280x768       74.9     60.0
>>      1280x720       50.0     60.0
>>      1024x768       75.1     70.1     60.0
>>      1024x576       60.0
>>      800x600        72.2     75.0     60.3     56.2
>>      720x576        50.0
>>      848x480        60.0
>>      720x480        59.9
>>      640x480        72.8     75.0     60.0     59.9     59.9
>>      720x400        70.1
>> DP1 disconnected (normal left inverted right x axis y axis)
>> HDMI2 disconnected (normal left inverted right x axis y axis)
>> HDMI3 disconnected (normal left inverted right x axis y axis)
>> DP2 disconnected (normal left inverted right x axis y axis)
>> DP3 disconnected (normal left inverted right x axis y axis)
>>
>> I'm still getting the same messages spewed into the kernel log file. So
>> this looks to me like the kernel is confused. Again, I ask, why do I have 3
>> HDMIs and 3 DPs but just one VGA.
>
> Maybe Daniel or Chris can comment on that high quantity of DP/HDMI
> connectors seen by driver. Those are probably also the cause of the
> persistent EDID complaints in kernel log.
>

What I see is that HDMI-1 is the DVI port, HDMI-3 is the HDMI port, so I 
assume HDMI-2 is that "other" video port.

If I set video=HDMI-A-1:d nothing comes out the DVI port and if I set 
HDMI-A-3:d nothing comes out the HDMI port. This is rather confusing. Is it 
correct?

>
> You could maybe try to disable those outputs in xorg.conf in order to not
> get your log filled with bad EDID complaints for "unused" connectors.
> But as specifying the EDID as firmware it's just a work-around to the
> issue.
>

These messages get spewed even if X is not running. The machine is 
unresponsive for 2-3 seconds when this happens.

Sure, specifying the EDID as firmware is a work around, but it's a work 
around that isn't working as intended on this hardware, for whatever 
reason. Seems like someone would be interested in fixing it? I've got a 
machine I could provide some access to?

Mark



