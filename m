Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009Ab2F0Txe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:53:34 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40469 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755752Ab2F0Txd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:53:33 -0400
Message-ID: <1340826809.3175.89.camel@dabdike.int.hansenpartnership.com>
Subject: Re: UEFI Secure boot using qemu-kvm
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Date: Wed, 27 Jun 2012 20:53:29 +0100
In-Reply-To: <20120627193806.GA10091@srcf.ucam.org>
References: <1340818445.3175.73.camel@dabdike.int.hansenpartnership.com>
	 <20120627181503.GA7775@srcf.ucam.org>
	 <1340825704.3175.88.camel@dabdike.int.hansenpartnership.com>
	 <20120627193806.GA10091@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 20:38 +0100, Matthew Garrett wrote:
> On Wed, Jun 27, 2012 at 08:35:04PM +0100, James Bottomley wrote:
> 
> > I've tried to build pesign, but I have huge problems with the make
> > process; how did you build it?
> 
> I checked it out and ran make. What problems ar eyou seeing?


jejb@dabdike> make
make -C include TOPDIR=/home/jejb/git/pesign
SRCDIR=/home/jejb/git/pesign/include/ ARCH=x86_64
make[1]: Entering directory `/home/jejb/git/pesign/include'
make -C libdpe TOPDIR=/home/jejb/git/pesign
SRCDIR=/home/jejb/git/pesign/libdpe/ ARCH=x86_64
make[2]: Entering directory `/home/jejb/git/pesign/include/libdpe'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/jejb/git/pesign/include/libdpe'
make[1]: Leaving directory `/home/jejb/git/pesign/include'
make -C libdpe TOPDIR=/home/jejb/git/pesign
SRCDIR=/home/jejb/git/pesign/libdpe/ ARCH=x86_64
make[1]: Entering directory `/home/jejb/git/pesign/libdpe'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/jejb/git/pesign/libdpe'
make -C src TOPDIR=/home/jejb/git/pesign
SRCDIR=/home/jejb/git/pesign/src/ ARCH=x86_64
make[1]: Entering directory `/home/jejb/git/pesign/src'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/jejb/git/pesign/src'
make -C util TOPDIR=/home/jejb/git/pesign
SRCDIR=/home/jejb/git/pesign/util/ ARCH=x86_64
make[1]: Entering directory `/home/jejb/git/pesign/util'
/usr/bin/gcc -I/home/jejb/git/pesign/include  -g -O0 -fpic -Wall
-fshort-wchar -fno-strict-aliasing -fno-merge-constants --std=gnu99
-D_GNU_SOURCE -DEFI_FUNCTION_WRAPPER -mno-red-zone -I/usr/include/efi/
-I/usr/include/efi/x86_64/ -I/usr/include/efi/protocol -fpic
-fshort-wchar -fno-reorder-functions -fno-strict-aliasing
-fno-merge-constants -mno-red-zone -Wimplicit-function-declaration
-DCONFIG_x86_64 -D__UEFI__ -c setupsb.c -o setupsb.o
In file included from /usr/include/efi/efi.h:35:0,
                 from setupsb.c:2:
/usr/include/efi/x86_64/efibind.h:88:1: error: unknown type name
‘uint64_t’
/usr/include/efi/x86_64/efibind.h:89:1: error: unknown type name
‘int64_t’
/usr/include/efi/x86_64/efibind.h:92:5: error: unknown type name
‘uint32_t’
/usr/include/efi/x86_64/efibind.h:93:5: error: unknown type name
‘int32_t’
/usr/include/efi/x86_64/efibind.h:96:1: error: unknown type name
‘uint16_t’
/usr/include/efi/x86_64/efibind.h:97:1: error: unknown type name
‘int16_t’
/usr/include/efi/x86_64/efibind.h:98:1: error: unknown type name
‘uint8_t’
/usr/include/efi/x86_64/efibind.h:99:1: error: unknown type name
‘int8_t’
/usr/include/efi/x86_64/efibind.h:106:1: error: unknown type name
‘int64_t’
/usr/include/efi/x86_64/efibind.h:107:1: error: unknown type name
‘uint64_t’
setupsb.c: In function ‘dumphex’:
setupsb.c:30:3: warning: passing argument 1 of ‘Print’ from incompatible
pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:33:4: warning: passing argument 1 of ‘Print’ from incompatible
pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:37:3: warning: passing argument 1 of ‘Print’ from incompatible
pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: In function ‘dumphex_str’:
setupsb.c:46:3: warning: passing argument 1 of ‘Print’ from incompatible
pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:49:4: warning: passing argument 1 of ‘Print’ from incompatible
pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:53:3: warning: passing argument 1 of ‘Print’ from incompatible
pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: In function ‘get_args’:
setupsb.c:62:27: error: ‘EFI_BOOT_SERVICES’ has no member named
‘OpenProtocol’
setupsb.c:66:5: error: ‘EFI_OPEN_PROTOCOL_GET_PROTOCOL’ undeclared
(first use in this function)
setupsb.c:66:5: note: each undeclared identifier is reported only once
for each function it appears in
setupsb.c:73:22: error: ‘EFI_BOOT_SERVICES’ has no member named
‘CloseProtocol’
setupsb.c: In function ‘pk_is_populated’:
setupsb.c:86:3: warning: passing argument 1 of ‘LibGetVariableAndSize’
from incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:511:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: In function ‘kek_is_populated’:
setupsb.c:100:3: warning: passing argument 1 of ‘LibGetVariableAndSize’
from incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:511:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: In function ‘db_is_populated’:
setupsb.c:114:3: warning: passing argument 1 of ‘LibGetVariableAndSize’
from incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:511:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: In function ‘make_variable’:
setupsb.c:143:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:153:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘usage’:
setupsb.c:172:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:176:8: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:177:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:178:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:179:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:180:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:181:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:182:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: In function ‘has_force’:
setupsb.c:190:3: warning: passing argument 2 of ‘StrCmp’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:200:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c: At top level:
setupsb.c:215:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:215:2: warning: (near initialization for ‘hashes[0].name’)
[enabled by default]
setupsb.c:216:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:216:2: warning: (near initialization for ‘hashes[1].name’)
[enabled by default]
setupsb.c:217:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:217:2: warning: (near initialization for ‘hashes[2].name’)
[enabled by default]
setupsb.c:218:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:218:2: warning: (near initialization for ‘hashes[3].name’)
[enabled by default]
setupsb.c: In function ‘get_hash’:
setupsb.c:235:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:238:3: warning: passing argument 2 of ‘StrCmp’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:200:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:241:6: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:242:5: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:256:5: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:257:5: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:265:5: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:266:5: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:277:6: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:279:6: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:290:2: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘get_file’:
setupsb.c:297:2: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘set_pk’:
setupsb.c:312:4: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:319:3: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:320:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘set_db_helper’:
setupsb.c:364:4: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘set_db’:
setupsb.c:394:5: warning: passing argument 6 of ‘set_db_helper’ from
incompatible pointer type [enabled by default]
setupsb.c:350:1: note: expected ‘CHAR16 *’ but argument is of type
‘short unsigned int *’
setupsb.c: In function ‘set_dbx’:
setupsb.c:402:5: warning: passing argument 6 of ‘set_db_helper’ from
incompatible pointer type [enabled by default]
setupsb.c:350:1: note: expected ‘CHAR16 *’ but argument is of type
‘short unsigned int *’
setupsb.c: In function ‘set_kek’:
setupsb.c:410:5: warning: passing argument 6 of ‘set_db_helper’ from
incompatible pointer type [enabled by default]
setupsb.c:350:1: note: expected ‘CHAR16 *’ but argument is of type
‘short unsigned int *’
setupsb.c: In function ‘append_db’:
setupsb.c:419:5: warning: passing argument 6 of ‘set_db_helper’ from
incompatible pointer type [enabled by default]
setupsb.c:350:1: note: expected ‘CHAR16 *’ but argument is of type
‘short unsigned int *’
setupsb.c: In function ‘append_dbx’:
setupsb.c:427:5: warning: passing argument 6 of ‘set_db_helper’ from
incompatible pointer type [enabled by default]
setupsb.c:350:1: note: expected ‘CHAR16 *’ but argument is of type
‘short unsigned int *’
setupsb.c: In function ‘append_kek’:
setupsb.c:435:5: warning: passing argument 6 of ‘set_db_helper’ from
incompatible pointer type [enabled by default]
setupsb.c:350:1: note: expected ‘CHAR16 *’ but argument is of type
‘short unsigned int *’
setupsb.c: In function ‘append_pk’:
setupsb.c:441:2: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:442:2: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘clear_db’:
setupsb.c:466:4: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:467:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: In function ‘clear_kek’:
setupsb.c:499:4: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:500:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c: At top level:
setupsb.c:517:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:517:2: warning: (near initialization for ‘actions[0].name’)
[enabled by default]
setupsb.c:517:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:517:2: warning: (near initialization for ‘actions[0].db’)
[enabled by default]
setupsb.c:518:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:518:2: warning: (near initialization for ‘actions[1].name’)
[enabled by default]
setupsb.c:518:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:518:2: warning: (near initialization for ‘actions[1].db’)
[enabled by default]
setupsb.c:519:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:519:2: warning: (near initialization for ‘actions[2].name’)
[enabled by default]
setupsb.c:519:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:519:2: warning: (near initialization for ‘actions[2].db’)
[enabled by default]
setupsb.c:520:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:520:2: warning: (near initialization for ‘actions[3].name’)
[enabled by default]
setupsb.c:520:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:520:2: warning: (near initialization for ‘actions[3].db’)
[enabled by default]
setupsb.c:521:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:521:2: warning: (near initialization for ‘actions[4].name’)
[enabled by default]
setupsb.c:521:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:521:2: warning: (near initialization for ‘actions[4].db’)
[enabled by default]
setupsb.c:522:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:522:2: warning: (near initialization for ‘actions[5].name’)
[enabled by default]
setupsb.c:522:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:522:2: warning: (near initialization for ‘actions[5].db’)
[enabled by default]
setupsb.c:523:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:523:2: warning: (near initialization for ‘actions[6].name’)
[enabled by default]
setupsb.c:523:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:523:2: warning: (near initialization for ‘actions[6].db’)
[enabled by default]
setupsb.c:524:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:524:2: warning: (near initialization for ‘actions[7].name’)
[enabled by default]
setupsb.c:524:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:524:2: warning: (near initialization for ‘actions[7].db’)
[enabled by default]
setupsb.c:525:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:525:2: warning: (near initialization for ‘actions[8].name’)
[enabled by default]
setupsb.c:525:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:525:2: warning: (near initialization for ‘actions[8].db’)
[enabled by default]
setupsb.c:526:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:526:2: warning: (near initialization for ‘actions[9].name’)
[enabled by default]
setupsb.c:526:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:526:2: warning: (near initialization for ‘actions[9].db’)
[enabled by default]
setupsb.c:527:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:527:2: warning: (near initialization for ‘actions[10].name’)
[enabled by default]
setupsb.c:527:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:527:2: warning: (near initialization for ‘actions[10].db’)
[enabled by default]
setupsb.c:528:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:528:2: warning: (near initialization for ‘actions[11].name’)
[enabled by default]
setupsb.c:528:2: warning: initialization from incompatible pointer type
[enabled by default]
setupsb.c:528:2: warning: (near initialization for ‘actions[11].db’)
[enabled by default]
setupsb.c: In function ‘efi_main’:
setupsb.c:545:3: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:550:3: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:553:3: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:557:3: warning: passing argument 2 of ‘StrCmp’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:200:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:558:5: warning: passing argument 2 of ‘StrCmp’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:200:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:559:5: warning: passing argument 2 of ‘StrCmp’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:200:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:560:5: warning: passing argument 2 of ‘StrCmp’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:200:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
setupsb.c:569:2: warning: overflow in implicit constant conversion
[-Woverflow]
setupsb.c:583:3: warning: passing argument 1 of ‘Print’ from
incompatible pointer type [enabled by default]
/usr/include/efi/efilib.h:388:1: note: expected ‘CHAR16 *’ but argument
is of type ‘short unsigned int *’
make[1]: *** [setupsb.o] Error 1
make[1]: Leaving directory `/home/jejb/git/pesign/util'
make: *** [util] Error 2

James


