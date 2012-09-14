Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2INHrs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:47:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33842 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2INHrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:47:46 -0400
MIME-Version: 1.0
Date: Fri, 14 Sep 2012 10:47:44 +0300
Message-ID: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
Subject: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to 3.6-rc5
 on AMD chipsets
From: Nikolay Ulyanitsky <lystor@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
I compiled the 3.6-rc5 kernel with the same config from 3.5.3 and got
the 15-20% performance drop of PostgreSQL 9.2 on AMD chipsets (880G,
990X).

CentOS 6.3 x86_64
PostgreSQL 9.2
cpufreq scaling_governor - performance

# /etc/init.d/postgresql initdb
# echo "fsync = off" >> /var/lib/pgsql/data/postgresql.conf
# /etc/init.d/postgresql start
# su - postgres
$ psql
# create database pgbench;
# \q

# pgbench -i pgbench && pgbench -c 10 -t 10000 pgbench
tps = 4670.635648 (including connections establishing)
tps = 4673.630345 (excluding connections establishing)[/code]

On kernel 3.5.3:
tps = ~5800

1) Host 1 - 15-20% performance drop
AMD Phenom(tm) II X6 1090T Processor
MB: AMD 880G
RAM: 16 Gb DDR3
SSD: PLEXTOR PX-256M3 256Gb

2) Host 2 - 15-20% performance drop
AMD Phenom(tm) II X6 1055T Processor
MB: AMD 990X
RAM: 32 Gb DDR3
SSD: Corsair Performance Pro 128Gb

3) Host 3 - no problems - same performance
Intel E6300
MB: Intel® P43 / ICH10
RAM: 4 Gb DDR3
HDD: SATA 7200 rpm

Kernel config - http://pastebin.com/cFpg5JSJ

Any ideas?

Thx
