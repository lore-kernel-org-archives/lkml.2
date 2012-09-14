Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab2INSkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:40:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51787 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759847Ab2INSka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:40:30 -0400
Date: Fri, 14 Sep 2012 20:40:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikolay Ulyanitsky <lystor@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets
Message-ID: <20120914184032.GA30753@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:47:44AM +0300, Nikolay Ulyanitsky wrote:
> Hi
> I compiled the 3.6-rc5 kernel with the same config from 3.5.3 and got
> the 15-20% performance drop of PostgreSQL 9.2 on AMD chipsets (880G,
> 990X).
> 
> CentOS 6.3 x86_64
> PostgreSQL 9.2
> cpufreq scaling_governor - performance
> 
> # /etc/init.d/postgresql initdb
> # echo "fsync = off" >> /var/lib/pgsql/data/postgresql.conf
> # /etc/init.d/postgresql start
> # su - postgres
> $ psql
> # create database pgbench;
> # \q
> 
> # pgbench -i pgbench && pgbench -c 10 -t 10000 pgbench
> tps = 4670.635648 (including connections establishing)
> tps = 4673.630345 (excluding connections establishing)[/code]

Ok, I was able to reproduce it here too, albeit with different userspace
(debian testing and postgres 9.1).

I'll try a coarse bisection of the -rcs first, to see where the
regression appeared.

Thanks for reporting this.

-- 
Regards/Gruss,
Boris.
