Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0KXEdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 23:33:40 -0500
Received: from mga03.intel.com ([143.182.124.21]:13924 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab0KXEdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 23:33:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,246,1288594800"; 
   d="scan'208";a="352572773"
From: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
To: Kyungmin Park <kmpark@infradead.org>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "Yuan, Hang" <hang.yuan@intel.com>
Date: Wed, 24 Nov 2010 12:33:33 +0800
Subject: RE: [PATCH v1 4/4]use HPI to interrupt background operations
Thread-Topic: [PATCH v1 4/4]use HPI to interrupt background operations
Thread-Index: AcuLjS9LCqUkKbtYQ6OjlThFx6lryQAA22Kw
Message-ID: <5D8008F58939784290FAB48F549751983125B43B49@shsmsx502.ccr.corp.intel.com>
References: <20101123084510.GE17754@intel.com>
 <AANLkTinF3+nUb8ugttyw-A_ss8cyX1iHFzG6bLdGf5d6@mail.gmail.com>
In-Reply-To: <AANLkTinF3+nUb8ugttyw-A_ss8cyX1iHFzG6bLdGf5d6@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       opcode = card->ext_csd.hpi_cmd;
> > +       if (opcode == MMC_STOP_TRANSMISSION)
> > +               flags = MMC_RSP_R1B | MMC_CMD_AC;
> > +       else if (opcode == MMC_SEND_STATUS)
> > +               flags = MMC_RSP_R1 | MMC_CMD_AC;
> > +       else
> > +               return -EINVAL;
> > +
> > +       memset(&cmd, 0, sizeof(struct mmc_command));
> > +       cmd.opcode = opcode;
> > +       cmd.arg = card->rca << 16 | 1;
> Maybe missing set the flags;
>             cmd.flags = flags;
> 
> Thank you,
> Kyungmin Park

Thank you Park, will fix these bad mistake in the next version submission.
