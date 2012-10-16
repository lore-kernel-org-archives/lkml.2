Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab2JPG7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 02:59:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:45247 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab2JPG7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 02:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
References: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
Date: Tue, 16 Oct 2012 15:58:59 +0900
Message-ID: <CAKYAXd_fT0Qk4C=AovO6Gp_6pEET_=BdVLHEz1kzQbm_D2AgyQ@mail.gmail.com>
Subject: Re: Initial report on F2FS filesystem performance
From: Namjae Jeon <linkinjeon@gmail.com>
To: Sooman Jeong <77smart@hanyang.ac.kr>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Would you share the result about random read ?

Thanks.

2012/10/16, Sooman Jeong <77smart@hanyang.ac.kr>:
>
> This is a brief summary of our initial filesystem performance study of f2fs
> against existing two filesystems in linux: EXT4, NILFS2, and f2fs.
>
>
> * test platform
> 　i) Desktop PC : Linux 3.6.1 (f2fs patched), Intel i5-2500 @3.3GHz
> quad-core, 8GB RAM, Transcend 16GB class 10 micro SD card
> 　ii) Galaxy-S3 : Linux 3.0.15 (f2fs ported), Android 4.0.4, DVFS turned off,
> Transcend 16GB class 10 micro SD card
>
>
> * experiment 1: buffered write(sequential and random, 4KByte write)
> ===================================================================
>
> F2FS surpasses other two filesystems in both random and sequential. In
> desktop and Galaxy S3, f2fs exhibits 2.5 and 1.6 times better performance in
> random write against EXT4, respectively. EXT4 is standard Android
> filesystem.
>
> buffered write (1GB file)
> +-------+---------------------------------+----------------------------------+
> |       |           Desktop PC            |            Galaxy-S3
> |
> |
> +-----------------+---------------+------------------+---------------+
> |       |sequential (MB/s)| random (IOPS) |sequential (MB/s) | random (IOPS)
> |
> +-------+-----------------+---------------+------------------+---------------+
> | EXT4  |        7.1      |     1073      |        6.7       |     1073
> |
> +-------+-----------------+---------------+------------------+---------------+
> | NILFS2|        6.8      |     1462      |        4.0       |     1272
> |
> +-------+-----------------+---------------+------------------+---------------+
> | F2FS  |       10.6      |     2675      |        6.9       |     1682
> |
> +-------+-----------------+---------------+------------------+---------------+
>
>
> * experiment 2: write + fsync(sequential and random)
> ====================================================
>
> F2FS surpasses other two filesystems in both random and sequential workload.
> In desktop and Galaxy S3, f2fs exhibits 2 and 1.5 times better performance
> in write+fsync random write against EXT4, respectively.
>
> write + fsync (100MB file)
> +-------+---------------------------------+----------------------------------+
> |       |           Desktop PC            |            Galaxy-S3
> |
> |
> +-----------------+---------------+------------------+---------------+
> |       |sequential (KB/s)| random (IOPS) |sequential (KB/s) | random (IOPS)
> |
> +-------+-----------------+---------------+------------------+---------------+
> | EXT4  |       511.8     |      125      |       383.4      |      119
> |
> +-------+-----------------+---------------+------------------+---------------+
> | NILFS2|       545.2     |      112      |       356.7      |       72
> |
> +-------+-----------------+---------------+------------------+---------------+
> | F2FS  |      1057.9     |      240      |       772.3      |      184
> |
> +-------+-----------------+---------------+------------------+---------------+
>
> write() with fsync is to test the filesystem performance under Android
> SQLite operation.
>
>
> * experiment 3: mounting time
> ===============================
>
> To measure the mount time, we used two different scenarios. First, we
> mounted file system after formatting without rebooting system. Second, we
> mounted file system after rebooting in order to ensure any data cached in
> memory is flushed. Overall, EXT4 shows fastest mount time, and F2FS shows
> second best performance; however, we observed that F2FS takes longest time
> to mount right after formatting.
>
> mounting time with Transcend 16GB micro-SD
> +-------+-----------------------------------+-----------------------------------+
> |       |           Desktop PC              |            Galaxy-S3
>    |
> |
> +-----------------+-----------------+-----------------+-----------------+
> |       |1st mount after  | after rebooting |1st mount after  | after
> rebooting |
> |       |format (msec)    | (msec)          |format (msec)    | (msec)
>    |
> +-------+-----------------+-----------------+-----------------+-----------------+
> | EXT4  |         11      |         20      |         20      |         40
>    |
> +-------+-----------------+-----------------+-----------------+-----------------+
> | NILFS2|        920      |       1013      |       1680      |       1630
>    |
> +-------+-----------------+-----------------+-----------------+-----------------+
> | F2FS  |       1486      |        161      |       2280      |       1570
>    |
> +-------+-----------------+-----------------+-----------------+-----------------+
>
>
> Sooman Jeong  ESOS Lab. Hanyang University.
> <77smart@hanyang.ac.kr>
