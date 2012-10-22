Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2JVLgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 07:36:50 -0400
Received: from spam1.hanyang.ac.kr ([166.104.177.29]:38354 "EHLO
	spam1.hanyang.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2JVLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 07:36:49 -0400
Date: Mon, 22 Oct 2012 20:36:43 +0900 (GMT)
From: Sooman Jeong <77smart@hanyang.ac.kr>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sooman Jeong <77smart@hanyang.ac.kr>, linux-kernel@vger.kernel.org,
        Vyacheslav Dubeyko <slava@dubeyko.com>
Message-ID: <1350905803450.1936.166.00.1.77smart@hanyang.ac.kr>
In-Reply-To: <20121021102638.GA14031@elf.ucw.cz>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
 <20121020192215.GB555@elf.ucw.cz>
 <E0328919-ACAA-4052-B922-952AFA375FD8@dubeyko.com>,<20121021102638.GA14031@elf.ucw.cz>
Subject: Re: Initial report on F2FS filesystem performance
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Priority: 3
X-Mailer: Postian WebMail Ver.5.30.1406
X-IP: 166.104.177.101
X-FROM-DOMAIN: hanyang.ac.kr
X-FROM-EMAIL: 77smart@hanyang.ac.kr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from BASE64 to 8bit by mail.home.local id q9MBaqE0028734


On Sun, 21 Oct 2012 12:26:38 +0200, Pavel Machek wrote:
>Hi!
>
>>>> This is a brief summary of our initial filesystem performance study of f2fs against
>>>> existing two filesystems in linux: EXT4, NILFS2, and f2fs.
>>>> 
>>> 
>>> Hmm, flashes are actually optimized for VFAT, right? Can you compare
>>> against that?
>>> 
>> 
>> Do you mean SD-cards? Because, as I can understand, "raw" flash (I mean NAND chip)
>> hasn't any special filesystem-related optimization. Moreover, as I know, this optimization
>> takes place in the begin of device (because FAT metadata is placed in the volume's begin).
>> But if you have several partition on a device then you haven't any optimizations for second
>> and next FAT partitions. So, in-place modified metadata of f2fs is placed in the begin of
>> the volume also.
>> 
>>Or, maybe, do you mean some another special optimization for VFAT? 
>> 
>
>I meant SD-card, sorry. Compare factory-formatted VFAT on SD card with
>f2fs running on the same partition.
>
>									Pavel
>-- 
>(english) http://www.livejournal.com/~pavelmachek
>(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Hi,

As requested, I compared performance of VFAT with f2fs on SD card.
Following is summary of the measurement.

VFAT shows better performance on both random write+fsync and buffered-sequential write than f2fs.
However, on buffered-random and sequential write+fsync, f2fs still exhibits better performance 
than other filesystems.


* buffered write (1GB file), 4KByte write
------------------------------------------------------------------------------
                     Desktop PC                         Galaxy-S3
------------------------------------------------------------------------------
         sequential (MB/s)  random (IOPS)  sequential (MB/s)   random (IOPS)  
------------------------------------------------------------------------------
  EXT4           7.1            1073               6.7             1073       
  NILFS2         6.8            1462               4.0             1272       
  F2FS          10.6            2675               6.9             1682      
  VFAT           7.3            1108               7.3             1075               
------------------------------------------------------------------------------


* write + fsync (100MB file), 4KByte write
------------------------------------------------------------------------------
                     Desktop PC                         Galaxy-S3
------------------------------------------------------------------------------
         sequential (KB/s)  random (IOPS)  sequential (KB/s)   random (IOPS)  
------------------------------------------------------------------------------
  EXT4          511.8            125              383.4             119
  NILFS2        545.2            112              356.7              72
  F2FS         1057.9            240              772.3             184
  VFAT          356.5            260              474.4             373
------------------------------------------------------------------------------


* buffered read (1GB file), 4KByte read
------------------------------------------------------------------------------
                     Desktop PC                         Galaxy-S3
------------------------------------------------------------------------------
         sequential (MB/s)  random (IOPS)  sequential (MB/s)   random (IOPS)  
------------------------------------------------------------------------------
  EXT4           16.4            1568               9.6             1395
  NILFS2         16.6            1609               9.6             1440
  F2FS           16.8            1643               9.7             1499
  VFAT           16.6            1592               9.6             1501
------------------------------------------------------------------------------
 * iozone command : iozone -i 0 -i 1 -i 2 -f /mnt/ext/test.txt -s 1G -r 4k -+n -e -U /mnt/ext


Sooman Jeong

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
