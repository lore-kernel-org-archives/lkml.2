Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2KSGqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 01:46:37 -0500
Received: from mail.enforta.com ([87.241.223.67]:62873 "EHLO mail.enforta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462Ab2KSGqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 01:46:36 -0500
X-Greylist: delayed 721 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Nov 2012 01:46:36 EST
Message-ID: <50A9D2F9.20703@enforta.com>
Date: Mon, 19 Nov 2012 10:34:33 +0400
From: "Volodin Arkady \"Enforta\"" <a.volodin@enforta.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 3.2.34 kernel bug: some SCSI definitions missing
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there!
Looks like it is bug in scsi.h with missing definitions in 3.2.34.
I compared scsi.h with one in 3.2.29 kernel and there are lots of 
definitions missing in 3.2.34:
18014 bytes in old file and only 7037 in new one.

   CC      block/scsi_ioctl.o
block/scsi_ioctl.c:1:0: warning: SSE instruction set disabled, using 387 
arithmetics
block/scsi_ioctl.c: In function 'blk_set_cmd_filter_defaults':
block/scsi_ioctl.c:124:12: error: 'READ_16' undeclared (first use in 
this function)
block/scsi_ioctl.c:124:12: note: each undeclared identifier is reported 
only once for each function it appears in
block/scsi_ioctl.c:135:12: error: 'VERIFY_16' undeclared (first use in 
this function)
block/scsi_ioctl.c:136:12: error: 'REPORT_LUNS' undeclared (first use in 
this function)
block/scsi_ioctl.c:137:12: error: 'SERVICE_ACTION_IN' undeclared (first 
use in this function)
block/scsi_ioctl.c:139:12: error: 'MAINTENANCE_IN' undeclared (first use 
in this function)
block/scsi_ioctl.c:174:12: error: 'WRITE_16' undeclared (first use in 
this function)
block/scsi_ioctl.c: In function 'blk_complete_sghdr_rq':
block/scsi_ioctl.c:257:2: error: implicit declaration of function 
'status_byte'
block/scsi_ioctl.c:258:2: error: implicit declaration of function 'msg_byte'
block/scsi_ioctl.c:259:2: error: implicit declaration of function 
'host_byte'
block/scsi_ioctl.c:260:2: error: implicit declaration of function 
'driver_byte'
block/scsi_ioctl.c: In function 'sg_scsi_ioctl':
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:443:2: warning: type defaults to 'int' in type name
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:445:2: warning: type defaults to 'int' in type name
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:6: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:449:2: warning: type defaults to 'int' in type name
block/scsi_ioctl.c:462:2: error: implicit declaration of function 
'COMMAND_SIZE'
block/scsi_ioctl.c:469:33: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:472:42: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:485:17: error: 'FORMAT_UNIT_TIMEOUT' undeclared 
(first use in this function)
block/scsi_ioctl.c:489:17: error: 'START_STOP_TIMEOUT' undeclared (first 
use in this function)
block/scsi_ioctl.c:492:17: error: 'MOVE_MEDIUM_TIMEOUT' undeclared 
(first use in this function)
block/scsi_ioctl.c:495:17: error: 'READ_ELEMENT_STATUS_TIMEOUT' 
undeclared (first use in this function)
block/scsi_ioctl.c:498:17: error: 'READ_DEFECT_DATA_TIMEOUT' undeclared 
(first use in this function)
block/scsi_ioctl.c:507:9: error: 'DRIVER_ERROR' undeclared (first use in 
this function)
block/scsi_ioctl.c:524:24: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c:528:23: error: dereferencing pointer to incomplete type
block/scsi_ioctl.c: In function 'scsi_cmd_ioctl':
block/scsi_ioctl.c:629:28: error: 'SG_DXFER_UNKNOWN' undeclared (first 
use in this function)
block/scsi_ioctl.c:647:12: warning: assignment from incompatible pointer 
type
block/scsi_ioctl.c: In function 'scsi_verify_blk_ioctl':
block/scsi_ioctl.c:705:7: error: 'SCSI_IOCTL_GET_PCI' undeclared (first 
use in this function)
make[1]: *** [block/scsi_ioctl.o] Error 1
make: *** [block] Error 2

