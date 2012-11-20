Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab2KTFs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 00:48:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:52055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2KTFs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 00:48:56 -0500
Message-ID: <50AB198B.1030000@infradead.org>
Date: Mon, 19 Nov 2012 21:47:55 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Volodin Arkady \"Enforta\"" <a.volodin@enforta.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: 3.2.34 kernel bug: some SCSI definitions missing
References: <50A9D2F9.20703@enforta.com>
In-Reply-To: <50A9D2F9.20703@enforta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 10:34 PM, Volodin Arkady "Enforta" wrote:

> Hi there!
> Looks like it is bug in scsi.h with missing definitions in 3.2.34.
> I compared scsi.h with one in 3.2.29 kernel and there are lots of definitions missing in 3.2.34:
> 18014 bytes in old file and only 7037 in new one.
> 


Yet include/scsi/scsi.h contains defines for READ_16, WRITE_16, VERIFY_16,
etc., and I had no problems building allmodconfig on i386 and x86_64.

If the problem is config-specific, you should include your
kernel .config file.

>   CC      block/scsi_ioctl.o
> block/scsi_ioctl.c:1:0: warning: SSE instruction set disabled, using 387 arithmetics
> block/scsi_ioctl.c: In function 'blk_set_cmd_filter_defaults':
> block/scsi_ioctl.c:124:12: error: 'READ_16' undeclared (first use in this function)
> block/scsi_ioctl.c:124:12: note: each undeclared identifier is reported only once for each function it appears in
> block/scsi_ioctl.c:135:12: error: 'VERIFY_16' undeclared (first use in this function)
> block/scsi_ioctl.c:136:12: error: 'REPORT_LUNS' undeclared (first use in this function)
> block/scsi_ioctl.c:137:12: error: 'SERVICE_ACTION_IN' undeclared (first use in this function)
> block/scsi_ioctl.c:139:12: error: 'MAINTENANCE_IN' undeclared (first use in this function)
> block/scsi_ioctl.c:174:12: error: 'WRITE_16' undeclared (first use in this function)
> block/scsi_ioctl.c: In function 'blk_complete_sghdr_rq':
> block/scsi_ioctl.c:257:2: error: implicit declaration of function 'status_byte'
> block/scsi_ioctl.c:258:2: error: implicit declaration of function 'msg_byte'
> block/scsi_ioctl.c:259:2: error: implicit declaration of function 'host_byte'
> block/scsi_ioctl.c:260:2: error: implicit declaration of function 'driver_byte'
> block/scsi_ioctl.c: In function 'sg_scsi_ioctl':
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:443:2: warning: type defaults to 'int' in type name
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:445:2: warning: type defaults to 'int' in type name
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:449:2: warning: type defaults to 'int' in type name
> block/scsi_ioctl.c:462:2: error: implicit declaration of function 'COMMAND_SIZE'
> block/scsi_ioctl.c:469:33: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:472:42: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:485:17: error: 'FORMAT_UNIT_TIMEOUT' undeclared (first use in this function)
> block/scsi_ioctl.c:489:17: error: 'START_STOP_TIMEOUT' undeclared (first use in this function)
> block/scsi_ioctl.c:492:17: error: 'MOVE_MEDIUM_TIMEOUT' undeclared (first use in this function)
> block/scsi_ioctl.c:495:17: error: 'READ_ELEMENT_STATUS_TIMEOUT' undeclared (first use in this function)
> block/scsi_ioctl.c:498:17: error: 'READ_DEFECT_DATA_TIMEOUT' undeclared (first use in this function)
> block/scsi_ioctl.c:507:9: error: 'DRIVER_ERROR' undeclared (first use in this function)
> block/scsi_ioctl.c:524:24: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c:528:23: error: dereferencing pointer to incomplete type
> block/scsi_ioctl.c: In function 'scsi_cmd_ioctl':
> block/scsi_ioctl.c:629:28: error: 'SG_DXFER_UNKNOWN' undeclared (first use in this function)
> block/scsi_ioctl.c:647:12: warning: assignment from incompatible pointer type
> block/scsi_ioctl.c: In function 'scsi_verify_blk_ioctl':
> block/scsi_ioctl.c:705:7: error: 'SCSI_IOCTL_GET_PCI' undeclared (first use in this function)
> make[1]: *** [block/scsi_ioctl.o] Error 1
> make: *** [block] Error 2


-- 
~Randy
