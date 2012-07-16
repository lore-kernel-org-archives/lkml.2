Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2GPCod (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:44:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52614 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2GPCob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdXgCR1HUwmwT21p=O2p+LuAqLfeM=Tn=ghvKQ+qgsNTTQ@mail.gmail.com>
References: <1340740795-19603-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdXgCR1HUwmwT21p=O2p+LuAqLfeM=Tn=ghvKQ+qgsNTTQ@mail.gmail.com>
Date: Mon, 16 Jul 2012 10:44:29 +0800
Message-ID: <CAA_GA1fsRiUD_XpHXJXV+R3zVuz-fvRGiD3ttQU4md0sL9t_vg@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc4
From: Bob Liu <lliubbo@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sonic Zhang <sonic.zhang@analog.com>, Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Sat, Jul 14, 2012 at 4:02 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Tue, Jun 26, 2012 at 9:59 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
>> + drivers/i2c/busses/i2c-bfin-twi.c: error: 'ANAK' undeclared (first use in this function):  => 154:19
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUFRDERR' undeclared (first use in this function):  => 158:19
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUFWRERR' undeclared (first use in this function):  => 160:19
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'BUSBUSY' undeclared (first use in this function):  => 401:35, 301:35
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'DNAK' undeclared (first use in this function):  => 156:19
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'FAST' undeclared (first use in this function):  => 511:17, 360:18
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'LOSTARB' undeclared (first use in this function):  => 152:19
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MCOMP' undeclared (first use in this function):  => 189:22, 489:31, 344:31
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MDIR' undeclared (first use in this function):  => 359:31, 567:32, 102:30
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MEN' undeclared (first use in this function):  => 358:51, 510:52, 196:33
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'MERR' undeclared (first use in this function):  => 146:23, 489:24, 344:24
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'RCVSERV' undeclared (first use in this function):  => 489:49, 116:23, 344:49
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'RSTART' undeclared (first use in this function):  => 102:37
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'SCLOVR' undeclared (first use in this function):  => 171:29
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'SDAOVR' undeclared (first use in this function):  => 177:28
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'SDASEN' undeclared (first use in this function):  => 168:33
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'STOP' undeclared (first use in this function):  => 105:30
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'TWI_ENA' undeclared (first use in this function):  => 398:30, 624:47, 298:30, 725:45
>>   + drivers/i2c/busses/i2c-bfin-twi.c: error: 'XMTSERV' undeclared (first use in this function):  => 344:39, 489:39, 90:23
>
> This seems to be caused by commit c55c89e939f2a0a83d5c61462be554d5d2408178
> ("blackfin: twi: move twi bit mask macro to twi head file").
> However, just including <asm/bfin_twi.h> doesn't fix it, as commit
> 1e92bf6d80b5a0a137455c96bf6cdd9c1a5b531e ("blackfin: twi: Move TWI MMR access
> macro to twi head file") created lots of duplicate definitions:
>
> arch/blackfin/include/asm/bfin_twi.h:87:6: warning: "ANOMALY_05001001"
> is not defined [-Wundef]
> arch/blackfin/include/asm/bfin_twi.h:67:0: note: this is the location
> of the previous definition
> drivers/i2c/busses/i2c-bfin-twi.c:36:8: error: redefinition of 'struct
> bfin_twi_iface'
> arch/blackfin/include/asm/bfin_twi.h:46:8: note: originally defined here
> arch/blackfin/include/asm/bfin_twi.h:73:90: note: previous definition
> of 'read_CLKDIV' was here
> arch/blackfin/include/asm/bfin_twi.h:73:259: note: previous definition
> of 'write_CLKDIV' was here
> arch/blackfin/include/asm/bfin_twi.h:74:90: note: previous definition
> of 'read_CONTROL' was here
> arch/blackfin/include/asm/bfin_twi.h:74:261: note: previous definition
> of 'write_CONTROL' was here
> arch/blackfin/include/asm/bfin_twi.h:75:90: note: previous definition
> of 'read_SLAVE_CTL' was here
> arch/blackfin/include/asm/bfin_twi.h:75:265: note: previous definition
> of 'write_SLAVE_CTL' was here
> arch/blackfin/include/asm/bfin_twi.h:76:90: note: previous definition
> of 'read_SLAVE_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:76:267: note: previous definition
> of 'write_SLAVE_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:77:90: note: previous definition
> of 'read_SLAVE_ADDR' was here
> arch/blackfin/include/asm/bfin_twi.h:77:267: note: previous definition
> of 'write_SLAVE_ADDR' was here
> arch/blackfin/include/asm/bfin_twi.h:78:90: note: previous definition
> of 'read_MASTER_CTL' was here
> arch/blackfin/include/asm/bfin_twi.h:78:267: note: previous definition
> of 'write_MASTER_CTL' was here
> arch/blackfin/include/asm/bfin_twi.h:79:90: note: previous definition
> of 'read_MASTER_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:79:269: note: previous definition
> of 'write_MASTER_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:80:90: note: previous definition
> of 'read_MASTER_ADDR' was here
> arch/blackfin/include/asm/bfin_twi.h:80:269: note: previous definition
> of 'write_MASTER_ADDR' was here
> arch/blackfin/include/asm/bfin_twi.h:81:90: note: previous definition
> of 'read_INT_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:81:263: note: previous definition
> of 'write_INT_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:82:90: note: previous definition
> of 'read_INT_MASK' was here
> arch/blackfin/include/asm/bfin_twi.h:82:263: note: previous definition
> of 'write_INT_MASK' was here
> arch/blackfin/include/asm/bfin_twi.h:83:90: note: previous definition
> of 'read_FIFO_CTL' was here
> arch/blackfin/include/asm/bfin_twi.h:83:263: note: previous definition
> of 'write_FIFO_CTL' was here
> arch/blackfin/include/asm/bfin_twi.h:84:90: note: previous definition
> of 'read_FIFO_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:84:265: note: previous definition
> of 'write_FIFO_STAT' was here
> arch/blackfin/include/asm/bfin_twi.h:85:90: note: previous definition
> of 'read_XMT_DATA8' was here
> arch/blackfin/include/asm/bfin_twi.h:85:265: note: previous definition
> of 'write_XMT_DATA8' was here
> arch/blackfin/include/asm/bfin_twi.h:86:90: note: previous definition
> of 'read_XMT_DATA16' was here
> arch/blackfin/include/asm/bfin_twi.h:86:267: note: previous definition
> of 'write_XMT_DATA16' was here
> arch/blackfin/include/asm/bfin_twi.h:88:90: note: previous definition
> of 'read_RCV_DATA8' was here
> arch/blackfin/include/asm/bfin_twi.h:88:265: note: previous definition
> of 'write_RCV_DATA8' was here
> arch/blackfin/include/asm/bfin_twi.h:89:90: note: previous definition
> of 'read_RCV_DATA16' was here
> arch/blackfin/include/asm/bfin_twi.h:89:267: note: previous definition
> of 'write_RCV_DATA16' was here
>
> So I gave up. A pity, considering BF537-STAMP_defconfig is the only
> blackfin config
> in http://kisskb.ellerman.id.au/kisskb/branch/3/.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>

The fix patches have already in Wolfram Sang's i2c tree, i think it'll
be merged soon.

-- 
Regards,
--Bob
