Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1BVPrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:47:31 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:48855 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754292Ab1BVPra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:47:30 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Nus.rfMVM1n6tQlHSPpicMhnuFpgV20fUrOYnehDlWRr_z_
 fXHB81xxepDSJMyMv5l0SVFGW1mIWhNmCBi.7Kwzkt_fI5aRZ8x52pzgfuCm
 6FD5DvMVHWMbQ5T3sIj1kI2ChumAQpGMKECyeCbTBqvImicoErl.LcJtz.s8
 2U.PZejZJQcNx5JyJTjM1gg3V1KJNlIx76JFoP1EAUym84aMtt6IeOEHoE2G
 G
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 22 Feb 2011 09:47:26 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, lwoodman@redhat.com,
        Andi Kleen <ak@linux.intel.com>, arcange@redhat.com
Subject: Re: [PATCH 3/8] Preserve local node for KSM copies
In-Reply-To: <1298315270-10434-4-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1102220945210.16060@router.home>
References: <1298315270-10434-1-git-send-email-andi@firstfloor.org> <1298315270-10434-4-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Andi Kleen wrote:

> Add a alloc_page_vma_node that allows passing the "local" node in.
> Use it in ksm to allocate copy pages on the same node as
> the original as possible.

Why would that be useful? The shared page could be on a node that is not
near the process that maps the page. Would it not be better to allocate on
the node that is local to the process that maps the page?
