Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819Ab2F0JGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:06:06 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24648 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab2F0JGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:06:03 -0400
Date: Wed, 27 Jun 2012 12:05:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [SCSI] bfa: Implement LUN Masking feature using the SCSI Slave
 Callouts.
Message-ID: <20120627090555.GN31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This bug is still present in linux-next.

regards,
dan carpenter

On Wed, Jan 11, 2012 at 12:32:34PM +0300, Dan Carpenter wrote:
> Hello Krishna Gudipati,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 5b7db7af522d: "[SCSI] bfa: Implement LUN Masking feature 
> using the SCSI Slave Callouts." from Dec 20, 2011, leads to the 
> following Smatch complaint:
> 
> drivers/scsi/bfa/bfad_im.c +962 bfad_im_slave_alloc()
> 	 warn: variable dereferenced before check 'rport' (see line 959)
> 
> drivers/scsi/bfa/bfad_im.c
>    957          struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
>    958		struct bfad_itnim_data_s *itnim_data =
>    959					(struct bfad_itnim_data_s *) rport->dd_data;
>                                                                      ^^^^^^^
> New dereference.
> 
>    960		struct bfa_s *bfa = itnim_data->itnim->bfa_itnim->bfa;
>    961	
>    962		if (!rport || fc_remote_port_chkready(rport))
>                      ^^^^^
> Old check.
> 
>    963			return -ENXIO;
>    964	
> 
> regards,
> dan carpenter
> 
