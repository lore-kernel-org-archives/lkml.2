Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757907Ab2GFRdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 13:33:38 -0400
Received: from [216.32.181.186] ([216.32.181.186]:15159 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757775Ab2GFRde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 13:33:34 -0400
X-Forefront-Antispam-Report: CIP:65.55.171.153;KIP:(null);UIP:(null);IPV:NLI;H:VA3DIAHUB076.RED001.local;RD:smtp801.microsoftonline.com;EFVD:NLI
X-SpamScore: -10
X-BigFish: VPS-10(zz616Rzz1202hzz8275bhz2fh2a8h668h839h944hd25hf0ah107ah)
From: Scan Subscription <scan-subscription@coverity.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "axboe@kernel.dk" <axboe@kernel.dk>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "jkosina@suse.cz" <jkosina@suse.cz>
Date: Fri, 6 Jul 2012 10:32:00 -0700
Subject: New Defect found by Coverity Scan based on code change in last 1.5
 week
Thread-Topic: New Defect found by Coverity Scan based on code change in last
 1.5 week
Thread-Index: AQHNW5zoM+kIvgQy9kS0qpKfLOuuog==
Message-ID: <829BE905228AE14A9AE1A46E6F2E371605538D039F@VA3DIAXVS891.RED001.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-OriginatorOrg: coverity.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q66HXmBe004275

New Defect found by Coverity Scan based on code change in last 1.5 week

Defect Summary
________________________________________________________________________
** CID 200075: Free of array-typed value (BAD_FREE.array)
/linux/fs/splice.c: 317
Alexander Viro 

** CID 709210: Self assignment (NO_EFFECT.self_assign)
/linux/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: 100
Roland Dreier 

** CID 709213: Wrong sizeof argument (SIZEOF_MISMATCH.wrong_sizeof)
/linux/drivers/hid/hid-logitech-dj.c: 442
Jiri Kosina 

** CID 709214: Wrong sizeof argument (SIZEOF_MISMATCH.wrong_sizeof)
/linux/drivers/hid/hid-logitech-dj.c: 459
Jiri Kosina

** CID 709551: Logically dead code (DEADCODE.none)
/linux/drivers/block/mtip32xx/mtip32xx.c: 2660
Jens Axboe 

** CID 709552: Logically dead code (DEADCODE.none)
/linux/drivers/block/mtip32xx/mtip32xx.c: 2588
Jens Axboe 

________________________________________________________________________
Defect Details:
________________________________________________________________________
CID 200075: Free of array-typed value (BAD_FREE.array)

/linux/fs/splice.c: 317 ( array_assign)
   311     struct page *pages[PIPE_DEF_BUFFERS];
   312     struct partial_page partial[PIPE_DEF_BUFFERS];
...
   316     int error, page_nr;
>>> CID 200075: Free of array-typed value (BAD_FREE.array)
>>> Assigning: "spd.pages" = "pages".
   317     struct splice_pipe_desc spd = {
   318      .pages = pages,
   319      .partial = partial,
   320      .nr_pages_max = PIPE_DEF_BUFFERS,
   321      .flags = flags,
  
/linux/fs/splice.c: 503 ( incorrect_free)
   500     if (spd.nr_pages)
   501      error = splice_to_pipe(pipe, &spd);
   502    
>>> "splice_shrink_spd" frees incorrect pointer "spd.pages".
   503     splice_shrink_spd(&spd);
   504     return error;
   505    }
   506    
   507    /**
  
/linux/fs/splice.c: 317 ( array_assign)
   311     struct page *pages[PIPE_DEF_BUFFERS];
   312     struct partial_page partial[PIPE_DEF_BUFFERS];
...
   316     int error, page_nr;
>>> CID 200075: Free of array-typed value (BAD_FREE.array)
>>> Assigning: "spd.partial" = "partial".
   317     struct splice_pipe_desc spd = {
   318      .pages = pages,
   319      .partial = partial,
   320      .nr_pages_max = PIPE_DEF_BUFFERS,
   321      .flags = flags,
  
/linux/fs/splice.c: 503 ( incorrect_free)
   500     if (spd.nr_pages)
   501      error = splice_to_pipe(pipe, &spd);
   502    
>>> "splice_shrink_spd" frees incorrect pointer "spd.partial".
   503     splice_shrink_spd(&spd);
   504     return error;
   505    }
   506    
   507    /**
  
________________________________________________________________________
CID 709210: Self assignment (NO_EFFECT.self_assign)

/linux/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c: 100 ( self_assign)
   97         min(dev->attr.max_ord_per_qp, dev->attr.max_ird_per_qp);
   98     attr->max_qp_init_rd_atom = dev->attr.max_ord_per_qp;
   99     attr->max_srq = (dev->attr.max_qp - 1);
>>> CID 709210: Self assignment (NO_EFFECT.self_assign) Assignment 
>>> operation "attr->max_srq_sge = attr->max_srq_sge" has no effect.
   100     attr->max_srq_sge = attr->max_srq_sge;
   101     attr->max_srq_wr = dev->attr.max_rqe;
   102     attr->local_ca_ack_delay = dev->attr.local_ca_ack_delay;
   103     attr->max_fast_reg_page_list_len = 0;
   104     attr->max_pkeys = 1;
  
________________________________________________________________________
CID 709213: Wrong sizeof argument (SIZEOF_MISMATCH.wrong_sizeof)

/linux/drivers/hid/hid-logitech-dj.c: 442 ( suspicious_sizeof)
   439     struct dj_report *dj_report;
   440     int retval;
   441    
>>> CID 709213: Wrong sizeof argument (SIZEOF_MISMATCH.wrong_sizeof) 
>>> Passing argument "8UL /* sizeof (dj_report) */" to function "kzalloc" and then casting the return value to "struct dj_report *" is suspicious.  
>>> Did you intend to use "sizeof(*dj_report)" instead of "sizeof (dj_report)" ?
   442     dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
   443     if (!dj_report)
   444      return -ENOMEM;
   445     dj_report->report_id = REPORT_ID_DJ_SHORT;
   446     dj_report->device_index = 0xFF;
  
________________________________________________________________________
CID 709214: Wrong sizeof argument (SIZEOF_MISMATCH.wrong_sizeof)

/linux/drivers/hid/hid-logitech-dj.c: 459 (suspicious_sizeof)
   456     struct dj_report *dj_report;
   457     int retval;
   458    
>>> CID 709214: Wrong sizeof argument (SIZEOF_MISMATCH.wrong_sizeof) 
>>> Passing argument "8UL /* sizeof (dj_report) */" to function "kzalloc" and then casting the return value to "struct dj_report *" is suspicious.  
>>> Did you intend to use "sizeof(*dj_report)" instead of "sizeof (dj_report)" ?
   459     dj_report = kzalloc(sizeof(dj_report), GFP_KERNEL);
   460     if (!dj_report)
   461      return -ENOMEM;
   462     dj_report->report_id = REPORT_ID_DJ_SHORT;
   463     dj_report->device_index = 0xFF;
  
________________________________________________________________________
CID 709551: Logically dead code (DEADCODE)

/linux/drivers/block/mtip32xx/mtip32xx.c: 2660 
   2657     char buf[MTIP_DFS_MAX_BUF_SIZE];
   2658     int size = *offset;
   2659    
>>> CID 709551: Logically dead code (DEADCODE.none) After this line, the 
>>> value of "size" is equal to 0.
>>> Noticing condition "size".
   2660     if (!len || size)
   2661      return 0;
   2662    
>>> On this path, the condition "size < 0" cannot be true.
   2663     if (size < 0)
>>> Execution cannot reach this statement "return -22L;".
   2664      return -EINVAL;
   2665    
   2666     size += sprintf(&buf[size], "Flag-port : [ %08lX ]\n",
   2667           dd->port->flags);
   2668     size += sprintf(&buf[size], "Flag-dd   : [ %08lX ]\n",
  
________________________________________________________________________
CID 709552: Logically dead code (DEADCODE)

/linux/drivers/block/mtip32xx/mtip32xx.c: 2588 
   2585     int size = *offset;
   2586     int n;
   2587    
>>> CID 709552: Logically dead code (DEADCODE.none) After this line, the 
>>> value of "size" is equal to 0.
>>> Noticing condition "size".
   2588     if (!len || size)
   2589      return 0;
   2590    
>>> On this path, the condition "size < 0" cannot be true.
   2591     if (size < 0)
>>> Execution cannot reach this statement "return -22L;".
   2592      return -EINVAL;
   2593    
   2594     size += sprintf(&buf[size], "H/ S ACTive      : [ 0x");
   2595    
   2596     for (n = dd->slot_groups-1; n >= 0; n--)
  
________________________________________________________________________

Above code snippet provide you details information to know more about the defects.
You can also view the defect in Coverity Scan by visiting, http://scan5.coverity.com:8080  
Your username is usually your first part of your email address.
If you don't have a username, you can request one by emailing:  scan-admin@coverity.com
________________________________________________________________________

Thanks
SCAN-ADMIN 
Scan-admin@coverity.com
http://scan.coverity.comÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
