Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab1BIVRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:17:14 -0500
Received: from imp01.mtu.ru ([62.5.255.10]:46997 "EHLO imp01.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab1BIVRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:17:13 -0500
Message-ID: <4D5303C0.7010907@pavlinux.ru>
Date: Thu, 10 Feb 2011 00:14:40 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux. Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ru; rv:1.9.2.13) Gecko/20101206 Microsoft/666 Notepad
MIME-Version: 1.0
To: Andy Isaacson <adi@hexapodia.org>
Subject: Re: CONFIG_KERNEL_XZ obscure build failure if xz(1) not installed
References: <20110209195258.GN11874@hexapodia.org> <4D52F404.4000709@pavlinux.ru> <20110209203841.GQ11874@hexapodia.org>
In-Reply-To: <20110209203841.GQ11874@hexapodia.org>
X-Enigmail-Version: 1.1.2
OpenPGP: id=03742489
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

09.02.2011 23:38, Andy Isaacson пишет:
> On Wed, Feb 09, 2011 at 11:07:32PM +0300, Pavel Vasilyev wrote:
>>> The failure is obscured by trailing make output, and since a broken
>>> bzImage is created, "make install" succeeds, and the first visible
> [snip]
>>  :)
>>
>> Signed-off-by: Pavel Vasilyev <pavel@pavlinux.ru>
>> ---
>> diff --git a/scripts/xz_wrap.sh b/scripts/xz_wrap.sh
>> index 17a5798..5ec9d36 100644
>> --- a/scripts/xz_wrap.sh
>> +++ b/scripts/xz_wrap.sh
>> @@ -20,4 +20,4 @@ case $ARCH in
>>         sparc)          BCJ=--sparc ;;
>>  esac
>>
>> -exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB
>> +exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=32MiB || exit 1
>>
> 
> I get the same behavior with and without your patch, tested with both
> bash and dash.  (FWIW, /bin/sh on my systems is a symlink to /bin/dash.)
> 

# mv /usr/bin/xz /
# rm arch/x86/boot/compressed/vmlinux.bin*
# rm arch/x86/boot/bzImage
# make
# make
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CHK     include/linux/version.h
make[2]: `scripts/unifdef' is up to date.
  XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
/media/kernel/linux-2.6/scripts/xz_wrap.sh: line 23: exec: xz: not found
make[2]: *** [arch/x86/boot/compressed/vmlinux.bin.xz] Error 1
make[1]: *** [arch/x86/boot/compressed/vmlinux] Error 2
make: *** [bzImage] Error 2

# make install
sh /media/kernel/linux-2.6/arch/x86/boot/install.sh 2.6.38-rc4+
arch/x86/boot/bzImage \
        System.map "/boot"

 *** Missing file: arch/x86/boot/bzImage
 *** You need to run "make" before "make install".

make[1]: *** [install] Error 1
make: *** [install] Error 2



All work, without and with patch.  :-/


# sh --version
GNU bash, version 4.1.9(1)-release (x86_64-suse-linux-gnu)


-- 

                                                         Pavel.
