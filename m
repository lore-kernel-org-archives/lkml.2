Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab0LUAnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 19:43:20 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43501 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754388Ab0LUAnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 19:43:18 -0500
Message-ID: <4D0FF7E6.2060104@cs.wisc.edu>
Date: Mon, 20 Dec 2010 18:42:14 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>,
        Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        adam radford <aradford@gmail.com>,
        Kashyap Desai <Kashyap.Desai@lsi.com>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less w/ interrupts
 disabled internally
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 03:21 PM, Nicholas A. Bellinger wrote:
>   prepd_fault:
> @@ -1732,12 +1728,10 @@ fault:
>   		scsi_out(sc)->resid = scsi_out(sc)->length;
>   		scsi_in(sc)->resid = scsi_in(sc)->length;
>   	}
> -	done(sc);
> -	spin_lock(host->host_lock);
> +	sc->scsi_done(sc);
>   	return 0;


Did you mean to send this patch or a different one? I think you sent a 
patch with this before and I said it was wrong. Did you disagree with 
that comment or did you change something else so it now works?
