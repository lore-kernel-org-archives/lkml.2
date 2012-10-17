Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab2JQEoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 00:44:18 -0400
Received: from spam1.hanyang.ac.kr ([166.104.177.29]:45804 "EHLO
	spam1.hanyang.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877Ab2JQEoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 00:44:17 -0400
Date: Wed, 17 Oct 2012 13:44:07 +0900 (GMT)
From: Sooman Jeong <77smart@hanyang.ac.kr>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, YOUJIP WON <youjip.won@gmail.com>
Message-ID: <1350449047509.2800.151.00.1.77smart@hanyang.ac.kr>
In-Reply-To: <CAKYAXd_fT0Qk4C=AovO6Gp_6pEET_=BdVLHEz1kzQbm_D2AgyQ@mail.gmail.com>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>,<CAKYAXd_fT0Qk4C=AovO6Gp_6pEET_=BdVLHEz1kzQbm_D2AgyQ@mail.gmail.com>
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
X-MIME-Autoconverted: from BASE64 to 8bit by mail.home.local id q9H4iPDS001981


Tue, 16 Oct 2012 15:58:59 +0900, Namjae Jeon wrote:
>Hello.
>
>Would you share the result about random read ?
>
>Thanks.
>
>2012/10/16, Sooman Jeong <77smart@hanyang.ac.kr>:
>>
>> This is a brief summary of our initial filesystem performance study of f2fs
>> against existing two filesystems in linux: EXT4, NILFS2, and f2fs.
>>
>>
>> * test platform
>>   i) Desktop PC : Linux 3.6.1 (f2fs patched), Intel i5-2500 @3.3GHz
>> quad-core, 8GB RAM, Transcend 16GB class 10 micro SD card
>>   ii) Galaxy-S3 : Linux 3.0.15 (f2fs ported), Android 4.0.4, DVFS turned off,
>> Transcend 16GB class 10 micro SD card
>>
>>
>> * experiment 1: buffered write(sequential and random, 4KByte write)
>> ===================================================================
>>
>> F2FS surpasses other two filesystems in both random and sequential. In
>> desktop and Galaxy S3, f2fs exhibits 2.5 and 1.6 times better performance in
>> random write against EXT4, respectively. EXT4 is standard Android
>> filesystem.
>>
>> buffered write (1GB file)
>> ------------------------------------------------------------------------------
>>                      Desktop PC                         Galaxy-S3
>> ------------------------------------------------------------------------------
>>          sequential (MB/s)  random (IOPS)  sequential (MB/s)   random (IOPS)  
>> ------------------------------------------------------------------------------
>>   EXT4           7.1            1073               6.7             1073       
>>   NILFS2         6.8            1462               4.0             1272       
>>   F2FS          10.6            2675               6.9             1682       
>> ------------------------------------------------------------------------------
>>
>>
>> * experiment 2: write + fsync(sequential and random)
>> ====================================================
>>
>> F2FS surpasses other two filesystems in both random and sequential workload.
>> In desktop and Galaxy S3, f2fs exhibits 2 and 1.5 times better performance
>> in write+fsync random write against EXT4, respectively.
>>
>> write + fsync (100MB file)
>> ------------------------------------------------------------------------------
>>                      Desktop PC                         Galaxy-S3
>> ------------------------------------------------------------------------------
>>          sequential (KB/s)  random (IOPS)  sequential (KB/s)   random (IOPS)  
>> ------------------------------------------------------------------------------
>>   EXT4          511.8            125              383.4             119
>>   NILFS2        545.2            112              356.7              72
>>   F2FS         1057.9            240              772.3             184
>> ------------------------------------------------------------------------------
>>
>> write() with fsync is to test the filesystem performance under Android
>> SQLite operation.
>>
>>
>> * experiment 3: mounting time
>> ===============================
>>
>> To measure the mount time, we used two different scenarios. First, we
>> mounted file system after formatting without rebooting system. Second, we
>> mounted file system after rebooting in order to ensure any data cached in
>> memory is flushed. Overall, EXT4 shows fastest mount time, and F2FS shows
>> second best performance; however, we observed that F2FS takes longest time
>> to mount right after formatting.
>>
>> mounting time with Transcend 16GB micro-SD
>> ---------------------------------------------------------------------------------
>>                      Desktop PC                         Galaxy-S3
>> ---------------------------------------------------------------------------------
>>          1st mount after    after rebooting   1st mount after    after rebooting
>>          format (msec)      (msec)            format (msec)      (msec)
>> ---------------------------------------------------------------------------------
>>   EXT4            11                20                20                40
>>   NILFS2         920              1013              1680              1630
>>   F2FS          1486               161              2280              1570
>> ---------------------------------------------------------------------------------
>>
>>
>> Sooman Jeong  ESOS Lab. Hanyang University.
>> <77smart@hanyang.ac.kr>


As you have requested, I have attached result of read performance(iozone).

* experiment 4: read(sequential and random)
====================================================

F2FS shows slightly better read performance than other two filesystems in both
sequential and random workload.

buffered read (1GB file)
------------------------------------------------------------------------------
                     Desktop PC                         Galaxy-S3
------------------------------------------------------------------------------
         sequential (MB/s)  random (IOPS)  sequential (MB/s)   random (IOPS)  
------------------------------------------------------------------------------
  EXT4           16.4            1568               9.6             1395
  NILFS2         16.6            1609               9.6             1440
  F2FS           16.8            1643               9.7             1499
------------------------------------------------------------------------------
 * iozone command : iozone -i 0 -i 1 -i 2 -f /mnt/ext/test.txt -s 1G -r 4k -+n -e -U /mnt/ext
  

Sooman Jeong

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
