Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2JUOnM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 10:43:12 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:7442 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753667Ab2JUOnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 10:43:10 -0400
X-Authority-Analysis: v=2.0 cv=GZOVbHrL c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=0N38pj-gRz4A:10 a=05ChyHeVI94A:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=tCn2Fh6cjnEA:10 a=knlGOIr7Csoc-LFcfiIA:9 a=QEXdDO2ut3YA:10 a=2xqgG0JYw_UWkOhK:21 a=xwDa3HCh1wnhg57D:21 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <508409FC.6080805@cfl.rr.com>
Date: Sun, 21 Oct 2012 10:43:08 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        "markh@compro.net >> Mark Hounschell" <markh@compro.net>
Subject: drm_kms_helper problems
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a TV that appears to not provide proper EDID info to the HDMI or DVI 
ports of my Intel DH77DF motherboard. I received some pointers from this 
list that pointed me in the direction of creating my own EDID file and I 
now have a binary blob that matches what the service manual says is the 
proper EDID info.

But I am unable to get the drm_kms_helper module to load and use this file. 
My relevant kernel config options are.

CONFIG_DRM_KMS_HELPER=m
CONFIG_DRM_LOAD_EDID_FIRMWARE=y

my relevant kernel command line contains:

video=card0-HDMI-A-1:e 
drm_kms_helper.edid_firmware=card0-HDMI-A-1:edid/lg42lb9df_hdmi1.edid

The edid file:
# ls -al /lib/firmware/edid/lg42lb9df_hdmi1.edid
-rw-r--r-- 1 root root 256 Oct 16 05:46 /lib/firmware/edid/lg42lb9df_hdmi1.edid

connector info from /sys/class/drm/

card0  card0-DP-1  card0-DP-2  card0-DP-3  card0-HDMI-A-1  card0-HDMI-A-2 
card0-HDMI-A-3  card0-VGA-1  controlD64  version

And I don't really understand why I have 3 entries for the one hdmi port? 
Nor do I really understand _exactly_ how to define the connector in my 
kernel command line or which of the 3 connectors from /sys I should be 
using. I've tried different variants. Ie. card0-HDMI-A-1and HDMI-A-1.

The results in the kernel log file remain:

[    1.879654] drm_kms_helper: Unknown parameter `edid'

I assume I am doing something wrong but I have put some debug printks in 
kernel/params.c that shows me every call made to it and it's params. It is 
entered many times and I see a sequence to in the log file. As an example, 
the last one to call with params before drm_kms_helper is "late" and here 
are my debug prints for it:

[    0.840206] parse_args: Entered for late
[    0.840207] parse_args: doing = late
[    0.840208] parse_args: args  = 
root=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part4 
video=1024x768 
resume=/dev/disk/by-id/ata-INTEL_SSDSC2CW060A3_CVCV205106EB060AGN-part3 
splash=silent quiet vga=0x37e irqpoll video=card0-HDMI-A-1:e 
drm_kms_helper.edid_firmware=card0-HDMI-A-1:edid/lg42lb9df_hdmi1.edid
[    0.840209] parse_args: params =
[    0.840210] parse_args: num = 174
[    0.840210] parse_args: min_level = 7
[    0.840211] parse_args: max_level = 7

Now when it gets to drm_kms_helper this is what I get and this is certainly 
screwed up, I just don't know why.

[    1.879648] parse_args: Entered for drm_kms_helper
[    1.879648] parse_args: doing = drm_kms_helper
[    1.879649] parse_args: args  = edid
\xffffff86\xffffffe2\xfffffff8h\xffffff89\xffffff86\xffffffc0\xffffff80\xffffffff\xffffffffԒ\xffffffe2\xfffffff8T\xffffff86\xffffffe2\xfffffff88\xffffff89\xffffff86\xffffffc0\xffffffa4\xffffffff\xffffffffd\xffffff86\xffffffe2\xfffffff8
[    1.879650] parse_args: num = 2
[    1.879651] parse_args: min_level = -32768
[    1.879651] parse_args: max_level = 32767
[    1.879653]
\xffffff86\xffffffe2\xfffffff8h\xffffff89\xffffff86\xffffffc0\xffffff80\xffffffff\xffffffffԒ\xffffffe2\xfffffff8T\xffffff86\xffffffe2\xfffffff88\xffffff89\xffffff86\xffffffc0\xffffffa4\xffffffff\xffffffffd\xffffff86\xffffffe2\xfffffff8, 
num=2, min_level=-32768, max_level=32767

Then finally:

[    1.879654] drm_kms_helper: Unknown parameter `edid'

The additional printks I inserted into kernel/params.c:

         if (*args)
                 pr_debug("doing %s, parsing ARGS: '%s'\n", doing, args);

+      if (*args) {
+              printk("\nparse_args: Entered for %s\n", doing);
+              printk("parse_args: doing = %s\n", doing);
+              printk("parse_args: args  = %s\n", args);
+              printk("parse_args: params = %s\n", params);
+              printk("parse_args: num = %d\n", num);
+              printk("parse_args: min_level = %d\n",min_level);
+              printk("parse_args: max_level = %d\n", max_level);
+       }

         while (*args) {

This is using a vanilla 3.6.2 kernel. Any help would be appreciated.

Regards
Mark

