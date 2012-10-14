Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab2JNQyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 12:54:37 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:27216 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754707Ab2JNQyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 12:54:36 -0400
X-Authority-Analysis: v=2.0 cv=OOOlLFmB c=1 sm=0 a=YPDeGStqRoQnMAluW+pq4Q==:17 a=65KWcu232dMA:10 a=h9GbcFHyNoYA:10 a=DpEkYpXRGzUA:10 a=05ChyHeVI94A:10 a=IkcTkHD0fZMA:10 a=ayC55rCoAAAA:8 a=nULq49Tkjo8A:10 a=eKWvBVOvAAAA:8 a=ed528wXd4RGLO5-vSJ8A:9 a=QEXdDO2ut3YA:10 a=YPDeGStqRoQnMAluW+pq4Q==:117
X-Cloudmark-Score: 0
X-Originating-IP: 50.89.247.146
Message-ID: <507AEE4A.1000907@cfl.rr.com>
Date: Sun, 14 Oct 2012 12:54:34 -0400
From: Mark Hounschell <dmarkh@cfl.rr.com>
Reply-To: dmarkh@cfl.rr.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120825 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
CC: markh@compro.net, linux-kernel@vger.kernel.org,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>
Subject: Re: Intel graphics drm issue?
References: <507812E8.3060607@compro.net> <20121012231459.166e29fd@neptune.home> <5079B97C.7020401@cfl.rr.com> <5079BE5C.8020401@cfl.rr.com> <20121014104138.7e8a9c59@neptune.home> <507A997D.7070508@cfl.rr.com> <20121014130323.06f0225d@neptune.home>
In-Reply-To: <20121014130323.06f0225d@neptune.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2012 07:03 AM, Bruno Prémont wrote:
> On Sun, 14 October 2012 Mark Hounschell <dmarkh@cfl.rr.com> wrote:
>> On 10/14/2012 04:41 AM, Bruno Prémont wrote:
>>> Your best solution is probably to write an EDID blob (or reuse one you find
>>> somewhere) that provides at least one mode matching your TV's native mode
>>> (probably full-HD).
>>>
>>> Google suggested the following document:
>>> http://www.jordansmanuals.com/ServiceManuals%5CLG%5CTV%5CLCD%5C42LB9DF%5C42LB9DF%20Service%20Manual.pdf
>>> which on page 13/14 shows the full EDID blob for the various HDMI outputs of the
>>> TV. You may want to read that document, convert the EDID blobs to 512 bytes binary
>>> files and hell DRM core to use the right one via module/kernel cmdline option:
>>>
>>>    drm_kms_helper.edid_firmware=edid/lg42lb9df.edid
>>> or
>>>    modprobe drm-kms-helper edid_firmware=edid/lg42lb9df.edid
>>>
>>> where
>>>    /lib/firmware/edid/lg42lb9df.edid
>>> is the 512-bytes EDID blob created according to data from above manual.
>>> (note, that will only work for intel, radeon and nouveau drivers but will
>>>    not work for closed drivers of AMD/nVidia)
>>>
>>
>> This certainly looks doable. That firmware file, should it contain all 4
>> tables or just the one for the port I'm connected to? Will it matter what
>> order they were in?
>
> It should contain just the table for the port you're connected to.
> For the HDMI ports the tables are 1024 bytes (e.g. two 512 bytes blocks,
> not just one as I incorrectly wrote above). For the VGA port it's just one
> 512 bytes block.
>
> Oh, and check the exact documentation of edid_firmware parameter as you can
> adjust its value to tell kernel to which connector exactly it applies
> (otherwise it will overwrite the EDID on other ports with working displays!).
>

Hi Bruno,

I've taken the EDID data from that service manual. I've looked at the 
EDID-Howto for how to specify the connector but all I see is:

"An EDID data set will only be used for a particular connector,
  if its name and a colon are prepended to the EDID name."

Where can I find the connector names?

And could I ask if this simple pgm might work to build the file I need?

int32_t main(int argc, char **argv)
{
         FILE *fd;
         const char *path = "/lib/firmware/edid/lg42lb9df.edid";
         const char *mode = "w+";
         uint8_t firmware[1024] = {

                 0x00, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x1E, 
0x6D, 0x01, 0x00, 0x01, 0x01, 0x01, 0x01,
                 0x0E, 0x10, 0x01, 0x03, 0x80, 0x73, 0x41, 0x96, 0x0A, 
0xCF, 0x74, 0xA3, 0x57, 0x4C, 0xB0, 0x23,
                 0x09, 0x48, 0x4C, 0xAF, 0xCF, 0x00, 0x31, 0x40, 0x45, 
0x40, 0x61, 0x40, 0x81, 0x80, 0xA9, 0x40,
                 0xD1, 0xC0, 0x01, 0x01, 0x01, 0x01, 0x02, 0x3A, 0x80, 
0x18, 0x71, 0x38, 0x2D, 0x40, 0x58, 0x2C,
                 0x45, 0x00, 0xC4, 0x8E, 0x21, 0x00, 0x00, 0x1E, 0x66, 
0x21, 0x50, 0xB0, 0x51, 0x00, 0x1B, 0x30,
                 0x40, 0x70, 0x36, 0x00, 0xC4, 0x8E, 0x21, 0x00, 0x00, 
0x1E, 0x00, 0x00, 0x00, 0xFD, 0x00, 0x38,
                 0x4B, 0x1F, 0x44, 0x0F, 0x00, 0x0A, 0x20, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0xFC,
                 0x00, 0x4C, 0x47, 0x20, 0x54, 0x56, 0x0A, 0x20, 0x20, 
0x20, 0x20, 0x20, 0x20, 0x20, 0x01, 0x15,

                 0x02, 0x03, 0x1B, 0xF1, 0x4C, 0x20, 0x22, 0x10, 0x1F, 
0x01, 0x02, 0x03, 0x04, 0x05, 0x12, 0x93,
                 0x14, 0x23, 0x15, 0x07, 0x50, 0x65, 0x03, 0x0C, 0x00, 
0x10, 0x00, 0x01, 0x1D, 0x00, 0x72, 0x51,
                 0xD0, 0x1E, 0x20, 0x6E, 0x28, 0x55, 0x00, 0xC4, 0x8E, 
0x21, 0x00, 0x00, 0x1E, 0x01, 0x1D, 0x80,
                 0x18, 0x71, 0x1C, 0x16, 0x20, 0x58, 0x2C, 0x25, 0x00, 
0xC4, 0x8E, 0x21, 0x00, 0x00, 0x9E, 0x8C,
                 0x0A, 0xD0, 0x90, 0x20, 0x40, 0x31, 0x20, 0x0C, 0x40, 
0x55, 0x00, 0x4C, 0x6C, 0x42, 0x00, 0x00,
                 0x18, 0x01, 0x1D, 0x00, 0xBC, 0x52, 0xD0, 0x1E, 0x20, 
0xB8, 0x28, 0x55, 0x40, 0x4C, 0x6C, 0x42,
                 0x00, 0x00, 0x1E, 0x01, 0x1D, 0x80, 0xD0, 0x72, 0x1C, 
0x16, 0x20, 0x10, 0x2C, 0x25, 0x80, 0x4C,
                 0x6C, 0x42, 0x00, 0x00, 0x9E, 0x00, 0x00, 0x00, 0x00, 
0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xED
         };

         fd = fopen(path, mode);
         if (fd == NULL) {
                 perror("/lib/firmware/edid/lg42lb9df.edid failed: ");
                 return 1;
         }

         fwrite(&firmware, 1024, 1, fd);

         fclose(fd);

         printf("Wrote 1024 bytes of edid data to %s\n", path);

         return 0;
}

Thanks very much
Mark

