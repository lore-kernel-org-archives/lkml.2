Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab0LEQNb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 11:13:31 -0500
Received: from mail-iw0-f194.google.com ([209.85.214.194]:35394 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab0LEQNa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 11:13:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D6zaxBYVHl7WO/kEX4LUvHpg+6Ziw71OJmfTIplpUhta31a7jlUDniA1+qcmghVa8J
         tTllT6MNHC0KCzaeY1N3bvGIhOvIKpTuZVLLAlGIAvRdP/qshk/WGcV/rm6UH0mnE4In
         eNT3YpiujgexZGHdK+uUh0e8P8B1RUBE7b64k=
MIME-Version: 1.0
In-Reply-To: <AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>
References: <20101204135732.GA12774@sepie.suse.cz>
	<AANLkTimeyo==XJWUaUs8EzJvA8azkk3sw9FXQhMjuo6M@mail.gmail.com>
Date: Sun, 5 Dec 2010 11:13:28 -0500
Message-ID: <AANLkTi=95UvsLTUFkS6bsFk9pO_iGgXfeoMf8BOVm0ed@mail.gmail.com>
Subject: Re: [GIT] kbuild and kconfig fixes for 2.6.37-rc5
From: Arnaud Lacombe <lacombar@gmail.com>
To: trapdoor6@gmail.com
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        brueckner@linux.vnet.ibm.com, mchehab@redhat.com,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Dec 5, 2010 at 10:42 AM, trapDoor <trapdoor6@gmail.com> wrote:
> On Sat, Dec 4, 2010 at 1:57 PM, Michal Marek <mmarek@suse.cz> wrote:
>> Hi Linus,
>>
>> please pull these kbuild/kconfig fixes for the next -rc. The largest
>> part are fixes for the annoying kconfig warnings, contributed by Arnaud
>> Lacombe and Mauro Carvalho Chehab. The solution adds a new 'visible if'
>> keyword to the Kconfig language, so it's not exactly something that one
>> would expect in the rc phase, but the kconfig change is not huge (the
>> large diff is due to generated files) and it is deployed only in those
>> five Kconfig files that had the warnings and were hard to fix by other
>> means.  The second part is a forgotten patch by Hendrik Brueckner to
>> usr/initramfs, that fixes build for Blackfin and h8300.
>>
>> Michal
>>
>> The following changes since commit e8a7e48bb248a1196484d3f8afa53bded2b24e71:
>>
>>  Linux 2.6.37-rc4 (2010-11-29 20:42:04 -0800)
>>
>> are available in the git repository at:
>>  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git rc-fixes
>>
>> Arnaud Lacombe (5):
>>      kconfig: add an option to determine a menu's visibility
>>      kconfig: regen parser
>>      Revert "i2c: Fix Kconfig dependencies"
>>      media/video: convert Kconfig to use the menu's `visible' keyword
>>      i2c/algos: convert Kconfig to use the menu's `visible' keyword
>>
>> Hendrik Brueckner (1):
>>      initramfs: Really fix build break on symbol-prefixed archs
>>
>> Mauro Carvalho Chehab (1):
>>      [media] Fix Kconfig errors due to two visible menus
>>
>> Michal Marek (1):
>>      Merge branch 'kconfig_fixes' of git://git.kernel.org/.../mchehab/linux-next into kbuild/rc-fixes
>>
>>  drivers/i2c/Kconfig                  |    3 +-
>>  drivers/i2c/algos/Kconfig            |   14 +-
>>  drivers/media/common/tuners/Kconfig  |    8 +-
>>  drivers/media/dvb/frontends/Kconfig  |    5 +-
>>  drivers/media/video/Kconfig          |    2 +-
>>  scripts/kconfig/expr.h               |    1 +
>>  scripts/kconfig/lkc.h                |    1 +
>>  scripts/kconfig/menu.c               |   11 +
>>  scripts/kconfig/zconf.gperf          |    1 +
>>  scripts/kconfig/zconf.hash.c_shipped |  122 ++++----
>>  scripts/kconfig/zconf.tab.c_shipped  |  570 +++++++++++++++++----------------
>>  scripts/kconfig/zconf.y              |   21 +-
>>  usr/initramfs_data.S                 |    5 +-
>>  13 files changed, 401 insertions(+), 363 deletions(-)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> Hello,
> I couldn't wait and I merged the changes into my copy of mainline
> tree. The merge was successful, no conflicts and the merge-diffstat
> was exactly the same as above. However, when  running oldconfig on the
> patched kernel I still get lots of warnings:
>
> warning: (GPIO_RDC321X && PCI && GPIOLIB) selects MFD_RDC321X which
> has unmet direct dependencies (MFD_SUPPORT && PCI)
> warning: (I2C_ISCH && I2C && PCI || GPIO_SCH && GPIOLIB && PCI ||
> GPIO_VX855 && GPIOLIB || GPIO_RDC321X && PCI && GPIOLIB ||
> MFD_88PM860X && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_ASIC3
> && MFD_SUPPORT && GENERIC_HARDIRQS && GPIOLIB && ARM ||
> MFD_SH_MOBILE_SDHI && MFD_SUPPORT && (SUPERH || ARCH_SHMOBILE) ||
> MFD_DAVINCI_VOICECODEC && MFD_SUPPORT || HTC_PASIC3 && MFD_SUPPORT ||
> TPS6507X && MFD_SUPPORT && I2C || TWL4030_CODEC && MFD_SUPPORT &&
> TWL4030_CORE || MFD_STMPE && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS
> || MFD_TC35892 && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS ||
> MFD_T7L66XB && MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6387XB &&
> MFD_SUPPORT && ARM && HAVE_CLK || MFD_TC6393XB && MFD_SUPPORT &&
> GPIOLIB && ARM || MFD_MAX8925 && MFD_SUPPORT && I2C=y &&
> GENERIC_HARDIRQS || MFD_MAX8998 && MFD_SUPPORT && I2C=y &&
> GENERIC_HARDIRQS || MFD_WM8400 && MFD_SUPPORT && I2C || MFD_WM831X_I2C
> && MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_WM831X_SPI &&
> MFD_SUPPORT && SPI_MASTER && GENERIC_HARDIRQS || MFD_WM8994 &&
> MFD_SUPPORT && I2C=y && GENERIC_HARDIRQS || MFD_MC13XXX && MFD_SUPPORT
> && SPI_MASTER || AB3100_CORE && MFD_SUPPORT && I2C=y && ABX500_CORE ||
> AB8500_CORE && MFD_SUPPORT && GENERIC_HARDIRQS && ABX500_CORE &&
> SPI_MASTER && ARCH_U8500 || AB3550_CORE && MFD_SUPPORT && I2C=y &&
> GENERIC_HARDIRQS && ABX500_CORE || MFD_TIMBERDALE && MFD_SUPPORT &&
> PCI && GPIOLIB || LPC_SCH && MFD_SUPPORT && PCI || MFD_RDC321X &&
> MFD_SUPPORT && PCI || MFD_JANZ_CMODIO && MFD_SUPPORT && PCI ||
> MFD_JZ4740_ADC && MFD_SUPPORT && MACH_JZ4740 || MFD_TPS6586X &&
> MFD_SUPPORT && I2C=y && GPIOLIB && GENERIC_HARDIRQS || MFD_VX855 &&
> MFD_SUPPORT && PCI) selects MFD_CORE which has unmet direct
> dependencies (MFD_SUPPORT)
>
Technically, this is two warning, though really verbose :)

>
> Were these warnings supposed to be fixed by this patch set as well? Or
> is it something in my config (attached)?
>
No. The kconfig language update is meant to be a solution for the +150
warnings triggered by the media and i2c tree, without making it
impossible to maintain. The notion of "dependency" was too strong for
the expected usage.

 - Arnaud

> --
> Thanks,
> Tomasz
>
