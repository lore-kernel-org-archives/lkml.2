Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab0JLWpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 18:45:44 -0400
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:42732 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751253Ab0JLWpm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 18:45:42 -0400
From: Jing Huang <huangj@Brocade.COM>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        scsi <linux-scsi@vger.kernel.org>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krishna Gudipati <kgudipat@Brocade.COM>,
        Maggie Zhang <xmzhang@Brocade.COM>
Date: Tue, 12 Oct 2010 15:44:44 -0700
Subject: RE: linux-next: Tree for October 12 (scsi/bfa)
Thread-Topic: linux-next: Tree for October 12 (scsi/bfa)
Thread-Index: ActqMTRkbGvRE/MERPSyi5DncyT7JwAKTCfA
Message-ID: <E5313AF6F2BFD14293E5FD0F94750F86A5CF75DA53@HQ1-EXCH01.corp.brocade.com>
References: <20101012163552.7306165b.sfr@canb.auug.org.au>
 <20101012101414.045f62d5.randy.dunlap@oracle.com>
In-Reply-To: <20101012101414.045f62d5.randy.dunlap@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-12_13:2010-10-12,2010-10-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=5
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=6.0.2-1004200000 definitions=main-1010120140
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>bfa has one function that probably uses too much stack space and a few
>others that might be a problem.
>
>With CONFIG_FRAME_WARN=1024:
>
>drivers/scsi/bfa/bfad_im.c:939: warning: the frame size of 1604 bytes is larger than
>1024 bytes
>
>and with CONFIG_FRAME_WARN=512:
>
>
>drivers/scsi/bfa/bfad.c: In function 'bfad_fcs_port_cfg':
>drivers/scsi/bfa/bfad.c:900: warning: the frame size of 676 bytes is larger than 512
>bytes
>drivers/scsi/bfa/bfad_im.c: In function 'bfad_im_supported_speeds':
>drivers/scsi/bfa/bfad_im.c:939: warning: the frame size of 1604 bytes is larger than
>512 bytes
>drivers/scsi/bfa/bfad_im.c: In function 'bfad_os_fc_host_init':
>drivers/scsi/bfa/bfad_im.c:976: warning: the frame size of 736 bytes is larger than
>512 bytes
>drivers/scsi/bfa/bfa_fcs_lport.c: In function
>'bfa_fcs_lport_fdmi_build_portattr_block':
>drivers/scsi/bfa/bfa_fcs_lport.c:2010: warning: the frame size of 572 bytes is larger
>than 512 bytes
>drivers/scsi/bfa/bfa_fcs_lport.c: In function 'bfa_fcs_lport_fdmi_build_rhba_pyld':
>drivers/scsi/bfa/bfa_fcs_lport.c:1803: warning: the frame size of 784 bytes is larger
>than 512 bytes
>

For these specific cases, we declare some big data structures in the stack, which is not good
and I will fix them. But is general, is passing 512 stack size check a requirement? This seems
too strict for me since the default stack size is 8k.

>Also, there are many comment blocks that begin with "/**", which means "beginning
>of kernel-doc comment block" for Linux kernel code.  :(
>

Not aware of this convention. I will fix them. Thanks.


