Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab1KDAoz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 20:44:55 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:34178 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753517Ab1KDAox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 20:44:53 -0400
Message-ID: <4EB33525.808@xenotime.net>
Date: Thu, 03 Nov 2011 17:43:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        x86 maintainers <x86@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for Nov 3 (KVMTOOL_TEST_ENABLE)
References: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
In-Reply-To: <20111103172036.0795ce9559ab2dbfd5740a26@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2011 11:20 PM, Stephen Rothwell wrote:
> Hi all,


When KVMTOOL_TEST_ENABLE is enabled but CONFIG_BLOCK is not enabled, there are
MANY build errors.  This one (case) is probably fixed by adding "select BLOCK", but it's
all rather ugly.


next-2011-1103/include/linux/loop.h:59:19: error: field 'lo_bio_list' has incomplete type
next-2011-1103/drivers/block/loop.c:201:2: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/loop.c:248:44: warning: 'struct bio_vec' declared inside parameter list
next-2011-1103/drivers/block/loop.c:248:44: warning: its scope is only this definition or declaration, which is probably not what you want
next-2011-1103/drivers/block/loop.c:251:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:251:30: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:252:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:253:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:266:22: warning: 'struct bio_vec' declared inside parameter list
next-2011-1103/drivers/block/loop.c:268:51: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:269:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:269:25: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:272:29: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:275:49: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:284:11: warning: 'struct bio_vec' declared inside parameter list
next-2011-1103/drivers/block/loop.c:294:14: warning: assignment from incompatible pointer type
next-2011-1103/drivers/block/loop.c:296:14: warning: assignment from incompatible pointer type
next-2011-1103/drivers/block/loop.c:299:2: error: implicit declaration of function 'bio_for_each_segment'
next-2011-1103/drivers/block/loop.c:299:37: error: expected ';' before '{' token
next-2011-1103/drivers/block/loop.c:315:1: warning: no return statement in function returning non-void
next-2011-1103/drivers/block/loop.c:362:15: warning: 'struct bio_vec' declared inside parameter list
next-2011-1103/drivers/block/loop.c:370:20: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:371:22: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:375:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:385:20: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:396:37: error: expected ';' before '{' token
next-2011-1103/drivers/block/loop.c:403:1: warning: no return statement in function returning non-void
next-2011-1103/drivers/block/loop.c:410:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:412:2: error: implicit declaration of function 'bio_rw'
next-2011-1103/drivers/block/loop.c:415:10: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:429:10: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:439:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:448:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:465:2: error: implicit declaration of function 'bio_list_add'
next-2011-1103/drivers/block/loop.c:473:2: error: implicit declaration of function 'bio_list_pop'
next-2011-1103/drivers/block/loop.c:478:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:498:2: error: implicit declaration of function 'bio_io_error'
next-2011-1103/drivers/block/loop.c:510:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:511:25: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:512:3: error: implicit declaration of function 'bio_put'
next-2011-1103/drivers/block/loop.c:515:3: error: implicit declaration of function 'bio_endio'
next-2011-1103/drivers/block/loop.c:538:2: error: implicit declaration of function 'bio_list_empty'
next-2011-1103/drivers/block/loop.c:565:9: error: implicit declaration of function 'bio_alloc'
next-2011-1103/drivers/block/loop.c:565:20: warning: initialization makes pointer from integer without a cast
next-2011-1103/drivers/block/loop.c:570:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:571:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:662:3: error: implicit declaration of function 'ioctl_by_bdev'
next-2011-1103/drivers/block/loop.c:683:9: error: implicit declaration of function 'dev_to_disk'
next-2011-1103/drivers/block/loop.c:683:25: warning: initialization makes pointer from integer without a cast
next-2011-1103/drivers/block/loop.c:684:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:745:1: warning: 'struct device_attribute' declared inside parameter list
next-2011-1103/drivers/block/loop.c:745:1: error: variable 'loop_attr_backing_file' has initializer but incomplete type
next-2011-1103/drivers/block/loop.c:745:1: error: unknown field 'attr' specified in initializer
next-2011-1103/drivers/block/loop.c:745:1: error: extra brace group at end of initializer
next-2011-1103/drivers/block/loop.c:745:1: error: (near initialization for 'loop_attr_backing_file')
next-2011-1103/drivers/block/loop.c:745:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:745:1: warning: (near initialization for 'loop_attr_backing_file')
next-2011-1103/drivers/block/loop.c:745:1: error: unknown field 'show' specified in initializer
next-2011-1103/drivers/block/loop.c:745:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:745:1: warning: (near initialization for 'loop_attr_backing_file')
next-2011-1103/drivers/block/loop.c:745:1: error: unknown field 'store' specified in initializer
next-2011-1103/drivers/block/loop.c:745:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:745:1: warning: (near initialization for 'loop_attr_backing_file')
next-2011-1103/drivers/block/loop.c:746:1: error: variable 'loop_attr_offset' has initializer but incomplete type
next-2011-1103/drivers/block/loop.c:746:1: error: unknown field 'attr' specified in initializer
next-2011-1103/drivers/block/loop.c:746:1: error: extra brace group at end of initializer
next-2011-1103/drivers/block/loop.c:746:1: error: (near initialization for 'loop_attr_offset')
next-2011-1103/drivers/block/loop.c:746:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:746:1: warning: (near initialization for 'loop_attr_offset')
next-2011-1103/drivers/block/loop.c:746:1: error: unknown field 'show' specified in initializer
next-2011-1103/drivers/block/loop.c:746:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:746:1: warning: (near initialization for 'loop_attr_offset')
next-2011-1103/drivers/block/loop.c:746:1: error: unknown field 'store' specified in initializer
next-2011-1103/drivers/block/loop.c:746:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:746:1: warning: (near initialization for 'loop_attr_offset')
next-2011-1103/drivers/block/loop.c:747:1: error: variable 'loop_attr_sizelimit' has initializer but incomplete type
next-2011-1103/drivers/block/loop.c:747:1: error: unknown field 'attr' specified in initializer
next-2011-1103/drivers/block/loop.c:747:1: error: extra brace group at end of initializer
next-2011-1103/drivers/block/loop.c:747:1: error: (near initialization for 'loop_attr_sizelimit')
next-2011-1103/drivers/block/loop.c:747:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:747:1: warning: (near initialization for 'loop_attr_sizelimit')
next-2011-1103/drivers/block/loop.c:747:1: error: unknown field 'show' specified in initializer
next-2011-1103/drivers/block/loop.c:747:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:747:1: warning: (near initialization for 'loop_attr_sizelimit')
next-2011-1103/drivers/block/loop.c:747:1: error: unknown field 'store' specified in initializer
next-2011-1103/drivers/block/loop.c:747:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:747:1: warning: (near initialization for 'loop_attr_sizelimit')
next-2011-1103/drivers/block/loop.c:748:1: error: variable 'loop_attr_autoclear' has initializer but incomplete type
next-2011-1103/drivers/block/loop.c:748:1: error: unknown field 'attr' specified in initializer
next-2011-1103/drivers/block/loop.c:748:1: error: extra brace group at end of initializer
next-2011-1103/drivers/block/loop.c:748:1: error: (near initialization for 'loop_attr_autoclear')
next-2011-1103/drivers/block/loop.c:748:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:748:1: warning: (near initialization for 'loop_attr_autoclear')
next-2011-1103/drivers/block/loop.c:748:1: error: unknown field 'show' specified in initializer
next-2011-1103/drivers/block/loop.c:748:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:748:1: warning: (near initialization for 'loop_attr_autoclear')
next-2011-1103/drivers/block/loop.c:748:1: error: unknown field 'store' specified in initializer
next-2011-1103/drivers/block/loop.c:748:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:748:1: warning: (near initialization for 'loop_attr_autoclear')
next-2011-1103/drivers/block/loop.c:749:1: error: variable 'loop_attr_partscan' has initializer but incomplete type
next-2011-1103/drivers/block/loop.c:749:1: error: unknown field 'attr' specified in initializer
next-2011-1103/drivers/block/loop.c:749:1: error: extra brace group at end of initializer
next-2011-1103/drivers/block/loop.c:749:1: error: (near initialization for 'loop_attr_partscan')
next-2011-1103/drivers/block/loop.c:749:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:749:1: warning: (near initialization for 'loop_attr_partscan')
next-2011-1103/drivers/block/loop.c:749:1: error: unknown field 'show' specified in initializer
next-2011-1103/drivers/block/loop.c:749:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:749:1: warning: (near initialization for 'loop_attr_partscan')
next-2011-1103/drivers/block/loop.c:749:1: error: unknown field 'store' specified in initializer
next-2011-1103/drivers/block/loop.c:749:1: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:749:1: warning: (near initialization for 'loop_attr_partscan')
next-2011-1103/drivers/block/loop.c:752:2: error: invalid use of undefined type 'struct device_attribute'
next-2011-1103/drivers/block/loop.c:753:2: error: invalid use of undefined type 'struct device_attribute'
next-2011-1103/drivers/block/loop.c:754:2: error: invalid use of undefined type 'struct device_attribute'
next-2011-1103/drivers/block/loop.c:755:2: error: invalid use of undefined type 'struct device_attribute'
next-2011-1103/drivers/block/loop.c:756:2: error: invalid use of undefined type 'struct device_attribute'
next-2011-1103/drivers/block/loop.c:767:2: error: implicit declaration of function 'disk_to_dev'
next-2011-1103/drivers/block/loop.c:767:53: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/loop.c:767:53: error: request for member 'kobj' in something not a structure or union
next-2011-1103/drivers/block/loop.c:773:46: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/loop.c:773:46: error: request for member 'kobj' in something not a structure or union
next-2011-1103/drivers/block/loop.c:791:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:791:4: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:791:12: error: request for member 'discard_granularity' in something not a structure or union
next-2011-1103/drivers/block/loop.c:792:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:792:4: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:792:12: error: request for member 'discard_alignment' in something not a structure or union
next-2011-1103/drivers/block/loop.c:793:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:793:4: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:793:12: error: request for member 'max_discard_sectors' in something not a structure or union
next-2011-1103/drivers/block/loop.c:794:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:794:4: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:794:12: error: request for member 'discard_zeroes_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:795:3: error: implicit declaration of function 'queue_flag_clear_unlocked'
next-2011-1103/drivers/block/loop.c:795:29: error: 'QUEUE_FLAG_DISCARD' undeclared (first use in this function)
next-2011-1103/drivers/block/loop.c:799:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:799:3: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:799:11: error: request for member 'discard_granularity' in something not a structure or union
next-2011-1103/drivers/block/loop.c:800:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:800:3: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:800:11: error: request for member 'discard_alignment' in something not a structure or union
next-2011-1103/drivers/block/loop.c:801:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:801:3: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:801:11: error: request for member 'max_discard_sectors' in something not a structure or union
next-2011-1103/drivers/block/loop.c:802:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:802:3: error: request for member 'limits' in something not a structure or union
next-2011-1103/drivers/block/loop.c:802:11: error: request for member 'discard_zeroes_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:803:2: error: implicit declaration of function 'queue_flag_set_unlocked'
next-2011-1103/drivers/block/loop.c:837:42: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:837:42: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:837:5: warning: assignment from incompatible pointer type
next-2011-1103/drivers/block/loop.c:866:2: error: implicit declaration of function 'set_device_ro'
next-2011-1103/drivers/block/loop.c:878:2: error: implicit declaration of function 'bio_list_init'
next-2011-1103/drivers/block/loop.c:884:2: error: implicit declaration of function 'blk_queue_make_request'
next-2011-1103/drivers/block/loop.c:885:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:885:14: error: request for member 'queuedata' in something not a structure or union
next-2011-1103/drivers/block/loop.c:888:3: error: implicit declaration of function 'blk_queue_flush'
next-2011-1103/drivers/block/loop.c:891:2: error: implicit declaration of function 'bd_set_size'
next-2011-1103/drivers/block/loop.c:894:44: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/loop.c:894:44: error: request for member 'kobj' in something not a structure or union
next-2011-1103/drivers/block/loop.c:921:44: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/loop.c:921:44: error: request for member 'kobj' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1013:45: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/loop.c:1013:45: error: request for member 'kobj' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1023:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1023:14: error: request for member 'flags' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1094:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1094:14: error: request for member 'flags' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1094:25: error: wrong type argument to bit-complement
next-2011-1103/drivers/block/loop.c:1261:2: error: implicit declaration of function 'get_capacity'
next-2011-1103/drivers/block/loop.c:1268:44: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/loop.c:1268:44: error: request for member 'kobj' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1278:40: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1278:40: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1278:27: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/loop.c:1449:40: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1449:40: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1449:27: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/loop.c:1488:20: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1488:20: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1488:5: warning: assignment from incompatible pointer type
next-2011-1103/drivers/block/loop.c:1504:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1504:31: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1504:27: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/loop.c:1534:21: error: variable 'lo_fops' has initializer but incomplete type
next-2011-1103/drivers/block/loop.c:1535:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/loop.c:1535:11: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:1535:11: warning: (near initialization for 'lo_fops')
next-2011-1103/drivers/block/loop.c:1536:2: error: unknown field 'open' specified in initializer
next-2011-1103/drivers/block/loop.c:1536:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:1536:2: warning: (near initialization for 'lo_fops')
next-2011-1103/drivers/block/loop.c:1537:2: error: unknown field 'release' specified in initializer
next-2011-1103/drivers/block/loop.c:1537:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:1537:2: warning: (near initialization for 'lo_fops')
next-2011-1103/drivers/block/loop.c:1538:2: error: unknown field 'ioctl' specified in initializer
next-2011-1103/drivers/block/loop.c:1538:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:1538:2: warning: (near initialization for 'lo_fops')
next-2011-1103/drivers/block/loop.c:1540:2: error: unknown field 'compat_ioctl' specified in initializer
next-2011-1103/drivers/block/loop.c:1540:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/loop.c:1540:2: warning: (near initialization for 'lo_fops')
next-2011-1103/drivers/block/loop.c:1553:29: error: expected declaration specifiers or '...' before numeric constant
next-2011-1103/drivers/block/loop.c:1553:1: warning: data definition has no type or storage class
next-2011-1103/drivers/block/loop.c:1553:1: warning: type defaults to 'int' in declaration of 'MODULE_ALIAS_BLOCKDEV_MAJOR'
next-2011-1103/drivers/block/loop.c:1553:29: warning: function declaration isn't a prototype
next-2011-1103/drivers/block/loop.c:1631:2: error: implicit declaration of function 'blk_alloc_queue'
next-2011-1103/drivers/block/loop.c:1631:15: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/loop.c:1635:2: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/loop.c:1635:21: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/loop.c:1658:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1658:7: error: request for member 'flags' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1659:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1659:6: error: request for member 'flags' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1665:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1665:6: error: request for member 'major' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1666:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1666:6: error: request for member 'first_minor' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1667:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1667:6: error: request for member 'fops' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1668:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1668:6: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1669:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1669:6: error: request for member 'queue' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1670:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1670:14: error: request for member 'disk_name' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1671:2: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/loop.c:1676:2: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/loop.c:1685:2: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/loop.c:1687:2: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/loop.c:1742:3: error: implicit declaration of function 'get_disk'
next-2011-1103/drivers/block/loop.c:1742:8: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/loop.c:1780:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/loop.c:1780:14: error: request for member 'private_data' in something not a structure or union
next-2011-1103/drivers/block/loop.c:1839:28: error: 'DISK_MAX_PARTS' undeclared (first use in this function)
next-2011-1103/drivers/block/loop.c:1861:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/loop.c:1864:2: error: implicit declaration of function 'blk_register_region'
next-2011-1103/drivers/block/loop.c:1895:2: error: implicit declaration of function 'blk_unregister_region'
next-2011-1103/drivers/block/loop.c:1896:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/cpqarray.c:189:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:194:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:198:21: error: variable 'ida_fops' has initializer but incomplete type
next-2011-1103/drivers/block/cpqarray.c:199:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/cpqarray.c:199:12: warning: excess elements in struct initializer
next-2011-1103/drivers/block/cpqarray.c:199:12: warning: (near initialization for 'ida_fops')
next-2011-1103/drivers/block/cpqarray.c:200:2: error: unknown field 'open' specified in initializer
next-2011-1103/drivers/block/cpqarray.c:200:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/cpqarray.c:200:2: warning: (near initialization for 'ida_fops')
next-2011-1103/drivers/block/cpqarray.c:201:2: error: unknown field 'release' specified in initializer
next-2011-1103/drivers/block/cpqarray.c:201:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/cpqarray.c:201:2: warning: (near initialization for 'ida_fops')
next-2011-1103/drivers/block/cpqarray.c:202:2: error: unknown field 'ioctl' specified in initializer
next-2011-1103/drivers/block/cpqarray.c:202:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/cpqarray.c:202:2: warning: (near initialization for 'ida_fops')
next-2011-1103/drivers/block/cpqarray.c:203:2: error: unknown field 'getgeo' specified in initializer
next-2011-1103/drivers/block/cpqarray.c:203:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/cpqarray.c:203:2: warning: (near initialization for 'ida_fops')
next-2011-1103/drivers/block/cpqarray.c:204:2: error: unknown field 'revalidate_disk' specified in initializer
next-2011-1103/drivers/block/cpqarray.c:204:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/cpqarray.c:204:2: warning: (near initialization for 'ida_fops')
next-2011-1103/drivers/block/cpqarray.c:338:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/cpqarray.c:346:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:347:4: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/cpqarray.c:348:3: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/cpqarray.c:350:2: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/cpqarray.c:404:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/cpqarray.c:417:3: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/cpqarray.c:417:21: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/cpqarray.c:437:2: error: implicit declaration of function 'blk_init_queue'
next-2011-1103/drivers/block/cpqarray.c:437:4: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/cpqarray.c:442:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:450:3: error: implicit declaration of function 'blk_queue_bounce_limit'
next-2011-1103/drivers/block/cpqarray.c:453:2: error: implicit declaration of function 'blk_queue_max_segments'
next-2011-1103/drivers/block/cpqarray.c:467:15: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:468:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:469:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:470:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:473:3: error: implicit declaration of function 'blk_queue_logical_block_size'
next-2011-1103/drivers/block/cpqarray.c:474:3: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/cpqarray.c:475:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:476:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:477:3: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/cpqarray.c:908:20: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:915:2: error: implicit declaration of function 'blk_peek_request'
next-2011-1103/drivers/block/cpqarray.c:915:7: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/cpqarray.c:919:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:924:2: error: implicit declaration of function 'blk_start_request'
next-2011-1103/drivers/block/cpqarray.c:927:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:931:2: error: implicit declaration of function 'blk_rq_pos'
next-2011-1103/drivers/block/cpqarray.c:938:2: error: implicit declaration of function 'blk_rq_map_sg'
next-2011-1103/drivers/block/cpqarray.c:941:2: error: implicit declaration of function 'rq_data_dir'
next-2011-1103/drivers/block/cpqarray.c:955:2: error: implicit declaration of function 'blk_rq_sectors'
next-2011-1103/drivers/block/cpqarray.c:1037:2: error: implicit declaration of function '__blk_end_request_all'
next-2011-1103/drivers/block/cpqarray.c:1542:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:1563:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:1564:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/cpqarray.c:1575:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:81:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:82:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:97:2: error: implicit declaration of function 'check_disk_change'
next-2011-1103/drivers/block/DAC960.c:99:2: error: implicit declaration of function 'get_capacity'
next-2011-1103/drivers/block/DAC960.c:110:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:111:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:146:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:147:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:150:10: error: 'DISK_EVENT_MEDIA_CHANGE' undeclared (first use in this function)
next-2011-1103/drivers/block/DAC960.c:156:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:157:23: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:159:2: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/DAC960.c:163:21: error: variable 'DAC960_BlockDeviceOperations' has initializer but incomplete type
next-2011-1103/drivers/block/DAC960.c:164:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/DAC960.c:164:13: warning: excess elements in struct initializer
next-2011-1103/drivers/block/DAC960.c:164:13: warning: (near initialization for 'DAC960_BlockDeviceOperations')
next-2011-1103/drivers/block/DAC960.c:165:2: error: unknown field 'open' specified in initializer
next-2011-1103/drivers/block/DAC960.c:165:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/DAC960.c:165:2: warning: (near initialization for 'DAC960_BlockDeviceOperations')
next-2011-1103/drivers/block/DAC960.c:166:2: error: unknown field 'getgeo' specified in initializer
next-2011-1103/drivers/block/DAC960.c:166:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/DAC960.c:166:2: warning: (near initialization for 'DAC960_BlockDeviceOperations')
next-2011-1103/drivers/block/DAC960.c:167:2: error: unknown field 'check_events' specified in initializer
next-2011-1103/drivers/block/DAC960.c:167:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/DAC960.c:167:2: warning: (near initialization for 'DAC960_BlockDeviceOperations')
next-2011-1103/drivers/block/DAC960.c:168:2: error: unknown field 'revalidate_disk' specified in initializer
next-2011-1103/drivers/block/DAC960.c:168:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/DAC960.c:168:2: warning: (near initialization for 'DAC960_BlockDeviceOperations')
next-2011-1103/drivers/block/DAC960.c:2527:3: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/DAC960.c:2535:4: error: implicit declaration of function 'blk_init_queue'
next-2011-1103/drivers/block/DAC960.c:2535:17: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/DAC960.c:2541:4: error: implicit declaration of function 'blk_queue_bounce_limit'
next-2011-1103/drivers/block/DAC960.c:2542:16: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:2543:2: error: implicit declaration of function 'blk_queue_max_segments'
next-2011-1103/drivers/block/DAC960.c:2544:2: error: implicit declaration of function 'blk_queue_max_hw_sectors'
next-2011-1103/drivers/block/DAC960.c:2545:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:2546:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:2547:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:2548:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:2549:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:2570:2: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/DAC960.c:2571:2: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/DAC960.c:2578:3: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/DAC960.c:2697:8: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/DAC960.c:2772:2: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/DAC960.c:2772:23: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/DAC960.c:2775:22: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:3177:9: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/DAC960.c:3332:2: error: implicit declaration of function 'blk_peek_request'
next-2011-1103/drivers/block/DAC960.c:3332:10: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/DAC960.c:3340:2: error: implicit declaration of function 'rq_data_dir'
next-2011-1103/drivers/block/DAC960.c:3347:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:3348:45: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:3349:2: error: implicit declaration of function 'blk_rq_pos'
next-2011-1103/drivers/block/DAC960.c:3350:2: error: implicit declaration of function 'blk_rq_sectors'
next-2011-1103/drivers/block/DAC960.c:3352:2: error: implicit declaration of function 'blk_start_request'
next-2011-1103/drivers/block/DAC960.c:3353:2: error: implicit declaration of function 'blk_rq_map_sg'
next-2011-1103/drivers/block/DAC960.c:3454:36: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/DAC960.c:3471:3: error: implicit declaration of function '__blk_end_request'
next-2011-1103/include/linux/blkdev.h:1344:42: warning: 'struct task_struct' declared inside parameter list
next-2011-1103/include/linux/blkdev.h:1344:42: warning: its scope is only this definition or declaration, which is probably not what you want
next-2011-1103/include/linux/blkdev.h:1348:51: warning: 'struct task_struct' declared inside parameter list
next-2011-1103/include/linux/blkdev.h:1353:48: warning: 'struct task_struct' declared inside parameter list
next-2011-1103/include/linux/pktcdvd.h:166:19: error: field 'read_queue' has incomplete type
next-2011-1103/include/linux/pktcdvd.h:167:19: error: field 'write_queue' has incomplete type
next-2011-1103/include/linux/pktcdvd.h:207:19: error: field 'orig_bios' has incomplete type
next-2011-1103/include/linux/pktcdvd.h:239:18: error: field 'rb_node' has incomplete type
next-2011-1103/include/linux/pktcdvd.h:279:18: error: field 'bio_queue' has incomplete type
next-2011-1103/include/scsi/scsi_cmnd.h:28:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
next-2011-1103/include/scsi/scsi_cmnd.h:184:2: error: implicit declaration of function 'blk_bidi_rq'
next-2011-1103/include/scsi/scsi_cmnd.h:185:16: error: dereferencing pointer to incomplete type
next-2011-1103/include/scsi/scsi_cmnd.h:191:15: error: dereferencing pointer to incomplete type
next-2011-1103/include/scsi/scsi_cmnd.h:269:2: error: implicit declaration of function 'blk_rq_pos'
next-2011-1103/drivers/block/pktcdvd.c:527:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:536:23: error: invalid application of 'sizeof' to incomplete type 'struct bio' 
next-2011-1103/drivers/block/pktcdvd.c:539:2: error: implicit declaration of function 'bio_init'
next-2011-1103/drivers/block/pktcdvd.c:541:34: error: invalid application of 'sizeof' to incomplete type 'struct bio_vec' 
next-2011-1103/drivers/block/pktcdvd.c:545:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:546:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:547:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:581:2: error: implicit declaration of function 'bio_list_init'
next-2011-1103/drivers/block/pktcdvd.c:596:4: error: implicit declaration of function 'bio_put'
next-2011-1103/drivers/block/pktcdvd.c:665:9: warning: type defaults to 'int' in declaration of '__mptr'
next-2011-1103/drivers/block/pktcdvd.c:665:9: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/pktcdvd.c:691:9: warning: type defaults to 'int' in declaration of '__mptr'
next-2011-1103/drivers/block/pktcdvd.c:691:9: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/pktcdvd.c:692:20: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:701:18: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:706:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:717:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:722:9: warning: type defaults to 'int' in declaration of '__mptr'
next-2011-1103/drivers/block/pktcdvd.c:722:9: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/pktcdvd.c:723:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:739:9: error: implicit declaration of function 'bdev_get_queue'
next-2011-1103/drivers/block/pktcdvd.c:739:28: warning: initialization makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:743:2: error: implicit declaration of function 'blk_get_request'
next-2011-1103/drivers/block/pktcdvd.c:743:5: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:747:3: error: implicit declaration of function 'blk_rq_map_kern'
next-2011-1103/drivers/block/pktcdvd.c:751:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:752:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:754:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:755:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:755:17: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
next-2011-1103/drivers/block/pktcdvd.c:757:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:759:2: error: implicit declaration of function 'blk_execute_rq'
next-2011-1103/drivers/block/pktcdvd.c:759:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:760:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:763:2: error: implicit declaration of function 'blk_put_request'
next-2011-1103/drivers/block/pktcdvd.c:851:2: error: implicit declaration of function 'bio_data_dir'
next-2011-1103/drivers/block/pktcdvd.c:852:3: error: implicit declaration of function 'bio_list_add'
next-2011-1103/drivers/block/pktcdvd.c:889:3: error: implicit declaration of function 'bio_list_empty'
next-2011-1103/drivers/block/pktcdvd.c:899:4: error: implicit declaration of function 'bio_list_peek'
next-2011-1103/drivers/block/pktcdvd.c:901:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:923:4: error: implicit declaration of function 'bio_list_pop'
next-2011-1103/drivers/block/pktcdvd.c:932:39: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:935:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:935:4: error: implicit declaration of function 'bio_sectors'
next-2011-1103/drivers/block/pktcdvd.c:950:3: error: implicit declaration of function 'generic_make_request'
next-2011-1103/drivers/block/pktcdvd.c:961:6: error: implicit declaration of function 'queue_max_segments'
next-2011-1103/drivers/block/pktcdvd.c:989:10: error: implicit declaration of function 'bio_iovec_idx'
next-2011-1103/drivers/block/pktcdvd.c:989:29: warning: initialization makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:990:3: error: implicit declaration of function 'kmap_atomic'
next-2011-1103/drivers/block/pktcdvd.c:990:36: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:991:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:993:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:997:3: error: implicit declaration of function 'kunmap_atomic'
next-2011-1103/drivers/block/pktcdvd.c:1013:65: warning: 'struct bio_vec' declared inside parameter list
next-2011-1103/drivers/block/pktcdvd.c:1021:3: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1021:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1022:4: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1022:34: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1022:4: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1022:63: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1026:4: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1026:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1027:4: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1027:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1029:4: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1029:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1041:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1059:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1093:2: error: implicit declaration of function 'bio_list_for_each'
next-2011-1103/drivers/block/pktcdvd.c:1093:42: error: expected ';' before '{' token
next-2011-1103/drivers/block/pktcdvd.c:1120:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1122:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1123:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1124:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1125:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1126:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1127:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1128:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1134:3: error: implicit declaration of function 'bio_add_page'
next-2011-1103/drivers/block/pktcdvd.c:1138:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1282:17: warning: type defaults to 'int' in declaration of '__mptr'
next-2011-1103/drivers/block/pktcdvd.c:1282:17: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/pktcdvd.c:1287:10: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1300:12: warning: type defaults to 'int' in declaration of '__mptr'
next-2011-1103/drivers/block/pktcdvd.c:1300:12: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/pktcdvd.c:1328:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1333:25: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1342:3: error: implicit declaration of function 'clear_bdi_congested'
next-2011-1103/drivers/block/pktcdvd.c:1342:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1343:6: error: 'BLK_RW_ASYNC' undeclared (first use in this function)
next-2011-1103/drivers/block/pktcdvd.c:1366:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1369:3: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1369:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1370:3: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1370:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1378:42: error: expected ';' before '{' token
next-2011-1103/drivers/block/pktcdvd.c:1422:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1423:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1424:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1425:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1426:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1427:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1428:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1430:3: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1430:37: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1430:3: error: invalid use of undefined type 'struct bio_vec'
next-2011-1103/drivers/block/pktcdvd.c:1430:68: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1435:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1448:3: error: implicit declaration of function 'bio_endio'
next-2011-1103/drivers/block/pktcdvd.c:1483:8: error: 'BIO_UPTODATE' undeclared (first use in this function)
next-2011-1103/drivers/block/pktcdvd.c:1483:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1483:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1500:15: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:1500:15: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2296:2: error: implicit declaration of function 'bdget'
next-2011-1103/drivers/block/pktcdvd.c:2297:2: error: implicit declaration of function 'blkdev_get'
next-2011-1103/drivers/block/pktcdvd.c:2305:2: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/pktcdvd.c:2307:2: error: implicit declaration of function 'bd_set_size'
next-2011-1103/drivers/block/pktcdvd.c:2309:4: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:2317:18: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2318:3: error: implicit declaration of function 'blk_queue_max_hw_sectors'
next-2011-1103/drivers/block/pktcdvd.c:2319:20: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2341:2: error: implicit declaration of function 'blkdev_put'
next-2011-1103/drivers/block/pktcdvd.c:2419:34: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2438:39: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2456:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2458:3: error: implicit declaration of function 'bdevname'
next-2011-1103/drivers/block/pktcdvd.c:2458:67: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2466:10: error: implicit declaration of function 'bio_clone'
next-2011-1103/drivers/block/pktcdvd.c:2466:28: warning: initialization makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:2471:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2472:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2473:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2474:26: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2481:37: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2485:10: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2485:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2490:2: error: implicit declaration of function 'blk_queue_bounce'
next-2011-1103/drivers/block/pktcdvd.c:2492:9: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2503:15: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2506:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2507:4: error: implicit declaration of function 'bio_split'
next-2011-1103/drivers/block/pktcdvd.c:2507:7: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:2509:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2510:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2511:4: error: implicit declaration of function 'bio_pair_release'
next-2011-1103/drivers/block/pktcdvd.c:2528:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2553:3: error: implicit declaration of function 'set_bdi_congested'
next-2011-1103/drivers/block/pktcdvd.c:2553:23: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2553:43: error: 'BLK_RW_ASYNC' undeclared (first use in this function)
next-2011-1103/drivers/block/pktcdvd.c:2556:4: error: implicit declaration of function 'congestion_wait'
next-2011-1103/drivers/block/pktcdvd.c:2589:2: error: implicit declaration of function 'bio_io_error'
next-2011-1103/drivers/block/pktcdvd.c:2595:13: warning: 'struct bio_vec' declared inside parameter list
next-2011-1103/drivers/block/pktcdvd.c:2595:13: warning: 'struct bvec_merge_data' declared inside parameter list
next-2011-1103/drivers/block/pktcdvd.c:2597:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2598:18: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2599:18: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2599:49: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2607:30: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2616:36: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2618:2: error: implicit declaration of function 'blk_queue_make_request'
next-2011-1103/drivers/block/pktcdvd.c:2619:2: error: implicit declaration of function 'blk_queue_logical_block_size'
next-2011-1103/drivers/block/pktcdvd.c:2621:2: error: implicit declaration of function 'blk_queue_merge_bvec'
next-2011-1103/drivers/block/pktcdvd.c:2622:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2633:6: warning: format '%s' expects type 'char *', but argument 4 has type 'int'
next-2011-1103/drivers/block/pktcdvd.c:2715:4: warning: format '%s' expects type 'char *', but argument 2 has type 'int'
next-2011-1103/drivers/block/pktcdvd.c:2724:7: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:2748:2: warning: format '%s' expects type 'char *', but argument 3 has type 'int'
next-2011-1103/drivers/block/pktcdvd.c:2760:43: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2784:3: error: implicit declaration of function '__blkdev_driver_ioctl'
next-2011-1103/drivers/block/pktcdvd.c:2799:34: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2807:38: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2809:22: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2812:21: error: variable 'pktcdvd_ops' has initializer but incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2813:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/pktcdvd.c:2813:12: warning: excess elements in struct initializer
next-2011-1103/drivers/block/pktcdvd.c:2813:12: warning: (near initialization for 'pktcdvd_ops')
next-2011-1103/drivers/block/pktcdvd.c:2814:2: error: unknown field 'open' specified in initializer
next-2011-1103/drivers/block/pktcdvd.c:2814:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/pktcdvd.c:2814:2: warning: (near initialization for 'pktcdvd_ops')
next-2011-1103/drivers/block/pktcdvd.c:2815:2: error: unknown field 'release' specified in initializer
next-2011-1103/drivers/block/pktcdvd.c:2815:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/pktcdvd.c:2815:2: warning: (near initialization for 'pktcdvd_ops')
next-2011-1103/drivers/block/pktcdvd.c:2816:2: error: unknown field 'ioctl' specified in initializer
next-2011-1103/drivers/block/pktcdvd.c:2816:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/pktcdvd.c:2816:2: warning: (near initialization for 'pktcdvd_ops')
next-2011-1103/drivers/block/pktcdvd.c:2817:2: error: unknown field 'check_events' specified in initializer
next-2011-1103/drivers/block/pktcdvd.c:2817:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/pktcdvd.c:2817:2: warning: (near initialization for 'pktcdvd_ops')
next-2011-1103/drivers/block/pktcdvd.c:2822:47: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2870:2: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/pktcdvd.c:2870:7: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/pktcdvd.c:2874:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2875:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2876:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2877:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2878:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2879:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2880:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2881:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2881:2: error: implicit declaration of function 'blk_alloc_queue'
next-2011-1103/drivers/block/pktcdvd.c:2882:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2891:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2891:34: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2892:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2892:40: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2894:2: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/pktcdvd.c:2907:2: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/pktcdvd.c:2907:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:2909:2: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/pktcdvd.c:2959:2: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/pktcdvd.c:2960:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/pktcdvd.c:3065:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/pktcdvd.c:3093:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/umem.c:355:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:356:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:357:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:360:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:367:2: error: implicit declaration of function 'bio_rw'
next-2011-1103/drivers/block/umem.c:371:2: error: implicit declaration of function 'bio_iovec_idx'
next-2011-1103/drivers/block/umem.c:371:6: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/umem.c:372:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:374:10: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:375:10: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:385:26: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:387:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:388:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:413:16: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:451:23: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:452:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:454:26: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:458:34: error: invalid type argument of '->' (have 'int')
next-2011-1103/drivers/block/umem.c:463:14: error: 'BIO_UPTODATE' undeclared (first use in this function)
next-2011-1103/drivers/block/umem.c:463:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:469:18: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:480:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:510:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:511:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:512:3: error: implicit declaration of function 'bio_endio'
next-2011-1103/drivers/block/umem.c:518:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:519:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:519:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:524:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:525:22: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:748:30: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:749:2: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/umem.c:755:39: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:769:21: error: variable 'mm_fops' has initializer but incomplete type
next-2011-1103/drivers/block/umem.c:770:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/umem.c:770:12: warning: excess elements in struct initializer
next-2011-1103/drivers/block/umem.c:770:12: warning: (near initialization for 'mm_fops')
next-2011-1103/drivers/block/umem.c:771:2: error: unknown field 'getgeo' specified in initializer
next-2011-1103/drivers/block/umem.c:771:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/umem.c:771:2: warning: (near initialization for 'mm_fops')
next-2011-1103/drivers/block/umem.c:772:2: error: unknown field 'revalidate_disk' specified in initializer
next-2011-1103/drivers/block/umem.c:772:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/umem.c:772:2: warning: (near initialization for 'mm_fops')
next-2011-1103/drivers/block/umem.c:880:2: error: implicit declaration of function 'blk_alloc_queue'
next-2011-1103/drivers/block/umem.c:880:14: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/umem.c:884:2: error: implicit declaration of function 'blk_queue_make_request'
next-2011-1103/drivers/block/umem.c:885:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:886:13: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1026:2: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/umem.c:1064:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/umem.c:1071:3: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/umem.c:1071:17: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/umem.c:1078:15: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1080:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1081:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1082:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1083:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1084:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/umem.c:1086:3: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/umem.c:1096:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/umem.c:1098:3: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/umem.c:1109:3: error: implicit declaration of function 'del_gendisk'
next-2011-1103/include/linux/loop.h:59:19: error: field 'lo_bio_list' has incomplete type
next-2011-1103/include/scsi/scsi_cmnd.h:28:3: error: #error MAX_COMMAND_SIZE can not be bigger than BLK_MAX_CDB
next-2011-1103/include/scsi/scsi_cmnd.h:184:2: error: implicit declaration of function 'blk_bidi_rq'
next-2011-1103/include/scsi/scsi_cmnd.h:185:16: error: dereferencing pointer to incomplete type
next-2011-1103/include/scsi/scsi_cmnd.h:191:15: error: dereferencing pointer to incomplete type
next-2011-1103/include/scsi/scsi_cmnd.h:269:2: error: implicit declaration of function 'blk_rq_pos'
next-2011-1103/drivers/block/virtio_blk.c:34:2: error: expected specifier-qualifier-list before 'mempool_t'
next-2011-1103/drivers/block/virtio_blk.c:81:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:82:8: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:83:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:84:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:85:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:87:8: error: 'REQ_TYPE_SPECIAL' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:88:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:94:3: error: implicit declaration of function '__blk_end_request_all'
next-2011-1103/drivers/block/virtio_blk.c:96:3: error: implicit declaration of function 'mempool_free'
next-2011-1103/drivers/block/virtio_blk.c:96:25: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:99:2: error: implicit declaration of function 'blk_start_queue'
next-2011-1103/drivers/block/virtio_blk.c:99:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:104:13: warning: 'struct request_queue' declared inside parameter list
next-2011-1103/drivers/block/virtio_blk.c:104:13: warning: its scope is only this definition or declaration, which is probably not what you want
next-2011-1103/drivers/block/virtio_blk.c:109:2: error: implicit declaration of function 'mempool_alloc'
next-2011-1103/drivers/block/virtio_blk.c:109:26: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:116:9: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:116:23: error: 'REQ_FLUSH' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:119:3: error: implicit declaration of function 'req_get_ioprio'
next-2011-1103/drivers/block/virtio_blk.c:121:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:122:8: error: 'REQ_TYPE_FS' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:127:8: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:132:8: error: 'REQ_TYPE_SPECIAL' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:143:18: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:151:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:152:19: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:152:40: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:152:55: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:154:2: error: implicit declaration of function 'blk_rq_map_sg'
next-2011-1103/drivers/block/virtio_blk.c:154:39: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:156:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:157:19: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:157:51: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:158:19: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:162:18: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:166:3: error: implicit declaration of function 'rq_data_dir'
next-2011-1103/drivers/block/virtio_blk.c:166:32: error: 'WRITE' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:175:38: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:176:25: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:184:39: warning: 'struct request_queue' declared inside parameter list
next-2011-1103/drivers/block/virtio_blk.c:186:29: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:190:2: error: implicit declaration of function 'blk_peek_request'
next-2011-1103/drivers/block/virtio_blk.c:190:14: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/virtio_blk.c:191:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:191:3: error: 'struct virtio_blk' has no member named 'sg_elems'
next-2011-1103/drivers/block/virtio_blk.c:196:4: error: implicit declaration of function 'blk_stop_queue'
next-2011-1103/drivers/block/virtio_blk.c:199:3: error: implicit declaration of function 'blk_start_request'
next-2011-1103/drivers/block/virtio_blk.c:211:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:216:2: error: implicit declaration of function 'bio_map_kern'
next-2011-1103/drivers/block/virtio_blk.c:216:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:221:2: error: implicit declaration of function 'blk_make_request'
next-2011-1103/drivers/block/virtio_blk.c:221:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:223:3: error: implicit declaration of function 'bio_put'
next-2011-1103/drivers/block/virtio_blk.c:227:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:227:18: error: 'REQ_TYPE_SPECIAL' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:228:2: error: implicit declaration of function 'blk_execute_rq'
next-2011-1103/drivers/block/virtio_blk.c:228:33: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:229:2: error: implicit declaration of function 'blk_put_request'
next-2011-1103/drivers/block/virtio_blk.c:235:9: warning: 'struct block_device' declared inside parameter list
next-2011-1103/drivers/block/virtio_blk.c:237:29: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:238:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:246:2: error: implicit declaration of function 'scsi_cmd_ioctl'
next-2011-1103/drivers/block/virtio_blk.c:246:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:251:59: warning: 'struct block_device' declared inside parameter list
next-2011-1103/drivers/block/virtio_blk.c:253:30: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:270:3: error: implicit declaration of function 'get_capacity'
next-2011-1103/drivers/block/virtio_blk.c:270:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:275:21: error: variable 'virtblk_fops' has initializer but incomplete type
next-2011-1103/drivers/block/virtio_blk.c:276:2: error: unknown field 'ioctl' specified in initializer
next-2011-1103/drivers/block/virtio_blk.c:276:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/virtio_blk.c:276:2: warning: (near initialization for 'virtblk_fops')
next-2011-1103/drivers/block/virtio_blk.c:277:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/virtio_blk.c:277:12: warning: excess elements in struct initializer
next-2011-1103/drivers/block/virtio_blk.c:277:12: warning: (near initialization for 'virtblk_fops')
next-2011-1103/drivers/block/virtio_blk.c:278:2: error: unknown field 'getgeo' specified in initializer
next-2011-1103/drivers/block/virtio_blk.c:278:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/virtio_blk.c:278:2: warning: (near initialization for 'virtblk_fops')
next-2011-1103/drivers/block/virtio_blk.c:294:9: error: implicit declaration of function 'dev_to_disk'
next-2011-1103/drivers/block/virtio_blk.c:294:25: warning: initialization makes pointer from integer without a cast
next-2011-1103/drivers/block/virtio_blk.c:315:3: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:315:3: warning: type defaults to 'int' in declaration of '__mptr'
next-2011-1103/drivers/block/virtio_blk.c:315:3: warning: initialization from incompatible pointer type
next-2011-1103/drivers/block/virtio_blk.c:315:3: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:317:38: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:332:2: error: implicit declaration of function 'queue_logical_block_size'
next-2011-1103/drivers/block/virtio_blk.c:342:2: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/virtio_blk.c:349:30: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:362:61: error: 'MINORBITS' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:380:20: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:389:6: error: 'struct virtio_blk' has no member named 'sg_elems'
next-2011-1103/drivers/block/virtio_blk.c:390:20: error: 'struct virtio_blk' has no member named 'sg'
next-2011-1103/drivers/block/virtio_blk.c:390:30: error: 'struct virtio_blk' has no member named 'sg_elems'
next-2011-1103/drivers/block/virtio_blk.c:391:2: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:391:2: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:391:2: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:391:2: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:391:2: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:400:6: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:400:2: error: implicit declaration of function 'mempool_create_kmalloc_pool'
next-2011-1103/drivers/block/virtio_blk.c:401:11: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:407:2: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/virtio_blk.c:407:13: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/virtio_blk.c:413:16: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:413:2: error: implicit declaration of function 'blk_init_queue'
next-2011-1103/drivers/block/virtio_blk.c:419:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:422:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:424:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:430:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:434:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:435:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:436:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:437:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:438:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:439:6: error: 'struct virtio_blk' has no member named 'index'
next-2011-1103/drivers/block/virtio_blk.c:443:3: error: implicit declaration of function 'blk_queue_flush'
next-2011-1103/drivers/block/virtio_blk.c:443:22: error: 'REQ_FLUSH' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:447:3: error: implicit declaration of function 'set_disk_ro'
next-2011-1103/drivers/block/virtio_blk.c:462:2: error: implicit declaration of function 'blk_queue_max_segments'
next-2011-1103/drivers/block/virtio_blk.c:462:32: error: 'struct virtio_blk' has no member named 'sg_elems'
next-2011-1103/drivers/block/virtio_blk.c:465:2: error: implicit declaration of function 'blk_queue_bounce_limit'
next-2011-1103/drivers/block/virtio_blk.c:465:28: error: 'BLK_BOUNCE_ANY' undeclared (first use in this function)
next-2011-1103/drivers/block/virtio_blk.c:468:2: error: implicit declaration of function 'blk_queue_max_hw_sectors'
next-2011-1103/drivers/block/virtio_blk.c:476:3: error: implicit declaration of function 'blk_queue_max_segment_size'
next-2011-1103/drivers/block/virtio_blk.c:485:3: error: implicit declaration of function 'blk_queue_logical_block_size'
next-2011-1103/drivers/block/virtio_blk.c:494:3: error: implicit declaration of function 'blk_queue_physical_block_size'
next-2011-1103/drivers/block/virtio_blk.c:501:3: error: implicit declaration of function 'blk_queue_alignment_offset'
next-2011-1103/drivers/block/virtio_blk.c:507:3: error: implicit declaration of function 'blk_queue_io_min'
next-2011-1103/drivers/block/virtio_blk.c:513:3: error: implicit declaration of function 'blk_queue_io_opt'
next-2011-1103/drivers/block/virtio_blk.c:516:2: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/virtio_blk.c:517:2: error: implicit declaration of function 'disk_to_dev'
next-2011-1103/drivers/block/virtio_blk.c:524:2: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/virtio_blk.c:525:2: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/virtio_blk.c:525:30: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:527:2: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/virtio_blk.c:529:2: error: implicit declaration of function 'mempool_destroy'
next-2011-1103/drivers/block/virtio_blk.c:529:22: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:543:18: error: 'struct virtio_blk' has no member named 'index'
next-2011-1103/drivers/block/virtio_blk.c:545:18: error: 'struct virtio_blk' has no member named 'config_work'
next-2011-1103/drivers/block/virtio_blk.c:554:30: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/virtio_blk.c:556:22: error: 'struct virtio_blk' has no member named 'pool'
next-2011-1103/drivers/block/virtio_blk.c:597:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/virtio_blk.c:609:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/sx8.c:410:63: warning: 'struct block_device' declared inside parameter list
next-2011-1103/drivers/block/sx8.c:410:63: warning: its scope is only this definition or declaration, which is probably not what you want
next-2011-1103/drivers/block/sx8.c:426:21: error: variable 'carm_bd_ops' has initializer but incomplete type
next-2011-1103/drivers/block/sx8.c:427:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/sx8.c:427:12: warning: excess elements in struct initializer
next-2011-1103/drivers/block/sx8.c:427:12: warning: (near initialization for 'carm_bd_ops')
next-2011-1103/drivers/block/sx8.c:428:2: error: unknown field 'getgeo' specified in initializer
next-2011-1103/drivers/block/sx8.c:428:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/sx8.c:428:2: warning: (near initialization for 'carm_bd_ops')
next-2011-1103/drivers/block/sx8.c:436:63: warning: 'struct block_device' declared inside parameter list
next-2011-1103/drivers/block/sx8.c:436:12: error: conflicting types for 'carm_bdev_getgeo'
next-2011-1103/drivers/block/sx8.c:438:31: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:570:2: error: implicit declaration of function 'blk_get_request'
next-2011-1103/drivers/block/sx8.c:570:36: error: 'WRITE' undeclared (first use in this function)
next-2011-1103/drivers/block/sx8.c:623:2: error: implicit declaration of function 'blk_insert_request'
next-2011-1103/drivers/block/sx8.c:752:2: error: implicit declaration of function '__blk_end_request_all'
next-2011-1103/drivers/block/sx8.c:762:2: error: implicit declaration of function 'blk_stop_queue'
next-2011-1103/drivers/block/sx8.c:787:3: error: implicit declaration of function 'blk_start_queue'
next-2011-1103/drivers/block/sx8.c:806:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:813:3: error: implicit declaration of function 'blk_fetch_request'
next-2011-1103/drivers/block/sx8.c:813:6: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/sx8.c:817:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:826:4: error: implicit declaration of function 'blk_requeue_request'
next-2011-1103/drivers/block/sx8.c:835:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:847:2: error: implicit declaration of function 'blk_peek_request'
next-2011-1103/drivers/block/sx8.c:847:5: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/sx8.c:858:2: error: implicit declaration of function 'blk_start_request'
next-2011-1103/drivers/block/sx8.c:860:2: error: implicit declaration of function 'rq_data_dir'
next-2011-1103/drivers/block/sx8.c:860:25: error: 'WRITE' undeclared (first use in this function)
next-2011-1103/drivers/block/sx8.c:869:2: error: implicit declaration of function 'blk_rq_map_sg'
next-2011-1103/drivers/block/sx8.c:904:2: error: implicit declaration of function 'blk_rq_pos'
next-2011-1103/drivers/block/sx8.c:907:2: error: implicit declaration of function 'blk_rq_sectors'
next-2011-1103/drivers/block/sx8.c:1053:30: error: 'WRITE' undeclared (first use in this function)
next-2011-1103/drivers/block/sx8.c:1332:5: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/sx8.c:1333:5: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/sx8.c:1501:3: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/sx8.c:1501:8: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/sx8.c:1508:15: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1510:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1511:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1512:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1513:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1515:3: error: implicit declaration of function 'blk_init_queue'
next-2011-1103/drivers/block/sx8.c:1515:5: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/sx8.c:1520:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1521:3: error: implicit declaration of function 'blk_queue_max_segments'
next-2011-1103/drivers/block/sx8.c:1522:3: error: implicit declaration of function 'blk_queue_segment_boundary'
next-2011-1103/drivers/block/sx8.c:1524:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1537:34: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1539:12: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1540:5: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/sx8.c:1542:5: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/sx8.c:1543:4: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/sx8.c:1638:4: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/sx8.c:1646:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/sx8.c:1661:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/sx8.c:1700:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/block/ub.c:519:21: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:520:4: error: implicit declaration of function 'blk_cleanup_queue'
next-2011-1103/drivers/block/ub.c:530:3: error: implicit declaration of function 'put_disk'
next-2011-1103/drivers/block/ub.c:629:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:632:2: error: implicit declaration of function 'blk_peek_request'
next-2011-1103/drivers/block/ub.c:632:13: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/ub.c:634:4: error: implicit declaration of function 'blk_stop_queue'
next-2011-1103/drivers/block/ub.c:648:3: error: implicit declaration of function 'blk_start_request'
next-2011-1103/drivers/block/ub.c:653:24: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:653:38: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
next-2011-1103/drivers/block/ub.c:675:2: error: implicit declaration of function 'blk_rq_map_sg'
next-2011-1103/drivers/block/ub.c:675:34: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:689:8: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:717:2: error: implicit declaration of function 'rq_data_dir'
next-2011-1103/drivers/block/ub.c:731:2: error: implicit declaration of function 'blk_rq_pos'
next-2011-1103/drivers/block/ub.c:732:2: error: implicit declaration of function 'blk_rq_sectors'
next-2011-1103/drivers/block/ub.c:744:2: error: implicit declaration of function 'blk_rq_bytes'
next-2011-1103/drivers/block/ub.c:764:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:764:2: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:765:19: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:773:17: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:786:9: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:786:23: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
next-2011-1103/drivers/block/ub.c:787:26: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:788:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:790:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:800:9: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:802:4: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:803:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:824:2: error: implicit declaration of function 'blk_start_queue'
next-2011-1103/drivers/block/ub.c:824:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:835:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:837:2: error: implicit declaration of function '__blk_end_request_all'
next-2011-1103/drivers/block/ub.c:1618:28: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1677:36: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1691:3: error: implicit declaration of function 'check_disk_change'
next-2011-1103/drivers/block/ub.c:1731:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1752:2: error: implicit declaration of function 'scsi_cmd_ioctl'
next-2011-1103/drivers/block/ub.c:1752:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1770:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1775:2: error: implicit declaration of function 'blk_queue_logical_block_size'
next-2011-1103/drivers/block/ub.c:1775:35: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1776:2: error: implicit declaration of function 'set_capacity'
next-2011-1103/drivers/block/ub.c:1794:27: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:1810:10: error: 'DISK_EVENT_MEDIA_CHANGE' undeclared (first use in this function)
next-2011-1103/drivers/block/ub.c:1816:21: error: variable 'ub_bd_fops' has initializer but incomplete type
next-2011-1103/drivers/block/ub.c:1817:2: error: unknown field 'owner' specified in initializer
next-2011-1103/drivers/block/ub.c:1817:12: warning: excess elements in struct initializer
next-2011-1103/drivers/block/ub.c:1817:12: warning: (near initialization for 'ub_bd_fops')
next-2011-1103/drivers/block/ub.c:1818:2: error: unknown field 'open' specified in initializer
next-2011-1103/drivers/block/ub.c:1818:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/ub.c:1818:2: warning: (near initialization for 'ub_bd_fops')
next-2011-1103/drivers/block/ub.c:1819:2: error: unknown field 'release' specified in initializer
next-2011-1103/drivers/block/ub.c:1819:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/ub.c:1819:2: warning: (near initialization for 'ub_bd_fops')
next-2011-1103/drivers/block/ub.c:1820:2: error: unknown field 'ioctl' specified in initializer
next-2011-1103/drivers/block/ub.c:1820:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/ub.c:1820:2: warning: (near initialization for 'ub_bd_fops')
next-2011-1103/drivers/block/ub.c:1821:2: error: unknown field 'check_events' specified in initializer
next-2011-1103/drivers/block/ub.c:1821:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/ub.c:1821:2: warning: (near initialization for 'ub_bd_fops')
next-2011-1103/drivers/block/ub.c:1822:2: error: unknown field 'revalidate_disk' specified in initializer
next-2011-1103/drivers/block/ub.c:1822:2: warning: excess elements in struct initializer
next-2011-1103/drivers/block/ub.c:1822:2: warning: (near initialization for 'ub_bd_fops')
next-2011-1103/drivers/block/ub.c:2330:2: error: implicit declaration of function 'alloc_disk'
next-2011-1103/drivers/block/ub.c:2330:12: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/ub.c:2333:14: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2334:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2335:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2336:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2337:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2338:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2341:2: error: implicit declaration of function 'blk_init_queue'
next-2011-1103/drivers/block/ub.c:2341:9: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/block/ub.c:2344:6: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2346:2: error: implicit declaration of function 'blk_queue_bounce_limit'
next-2011-1103/drivers/block/ub.c:2346:28: error: 'BLK_BOUNCE_HIGH' undeclared (first use in this function)
next-2011-1103/drivers/block/ub.c:2347:2: error: implicit declaration of function 'blk_queue_max_segments'
next-2011-1103/drivers/block/ub.c:2348:2: error: implicit declaration of function 'blk_queue_segment_boundary'
next-2011-1103/drivers/block/ub.c:2349:2: error: implicit declaration of function 'blk_queue_max_hw_sectors'
next-2011-1103/drivers/block/ub.c:2353:3: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2358:7: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/block/ub.c:2360:2: error: implicit declaration of function 'add_disk'
next-2011-1103/drivers/block/ub.c:2432:3: error: implicit declaration of function 'del_gendisk'
next-2011-1103/drivers/block/ub.c:2484:2: error: implicit declaration of function 'register_blkdev'
next-2011-1103/drivers/block/ub.c:2494:2: error: implicit declaration of function 'unregister_blkdev'
next-2011-1103/drivers/cdrom/cdrom.c:990:2: error: implicit declaration of function 'check_disk_change'
next-2011-1103/drivers/cdrom/cdrom.c:1094:7: error: implicit declaration of function 'task_pid_nr'
next-2011-1103/drivers/cdrom/cdrom.c:1454:28: error: 'DISK_EVENT_MEDIA_CHANGE' undeclared (first use in this function)
next-2011-1103/drivers/cdrom/cdrom.c:2152:37: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2167:3: error: implicit declaration of function 'queue_max_sectors'
next-2011-1103/drivers/cdrom/cdrom.c:2172:3: error: implicit declaration of function 'blk_get_request'
next-2011-1103/drivers/cdrom/cdrom.c:2172:6: warning: assignment makes pointer from integer without a cast
next-2011-1103/drivers/cdrom/cdrom.c:2178:3: error: implicit declaration of function 'blk_rq_map_user'
next-2011-1103/drivers/cdrom/cdrom.c:2180:4: error: implicit declaration of function 'blk_put_request'
next-2011-1103/drivers/cdrom/cdrom.c:2184:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2185:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2186:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2187:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2188:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2189:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2190:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2191:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2192:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2193:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2195:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2196:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2196:18: error: 'REQ_TYPE_BLOCK_PC' undeclared (first use in this function)
next-2011-1103/drivers/cdrom/cdrom.c:2197:5: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2198:11: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2200:3: error: implicit declaration of function 'blk_execute_rq'
next-2011-1103/drivers/cdrom/cdrom.c:2201:32: error: dereferencing pointer to incomplete type
next-2011-1103/drivers/cdrom/cdrom.c:2206:3: error: implicit declaration of function 'blk_rq_unmap_user'
next-2011-1103/drivers/cdrom/cdrom.c:2755:2: error: implicit declaration of function 'scsi_cmd_ioctl'
next-2011-1103/drivers/cdrom/cdrom.c:2755:27: error: dereferencing pointer to incomplete type


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
