Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab1LLDQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:16:43 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:26843 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab1LLDQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:16:41 -0500
Message-ID: <4EE57204.4030509@oracle.com>
Date: Mon, 12 Dec 2011 11:16:20 +0800
From: ANNIE LI <annie.li@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "jeremy@goop.org" <jeremy@goop.org>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>
Subject: Re: [PATCH V3 1/2] xen/granttable: Support sub-page grants
References: <1323430321-5465-1-git-send-email-annie.li@oracle.com>	 <1323430372-5503-1-git-send-email-annie.li@oracle.com> <1323452339.20077.92.camel@zakaz.uk.xensource.com>
In-Reply-To: <1323452339.20077.92.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EE57213.0077,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Please can you name the arguments here and then refer to them by name in
> the comments instead of all this "First parameter", "second one" stuff.
>
> Similarly for the existing comments sorry I didn't notice this in
> previous review.
Please check following comments in gnttab_ops, I changed the "First 
parameter", "second one" into parameter name. However, it looks not very 
consistent with parameters format of function fn since only parameter 
type exists, not name.

struct gnttab_ops {
         /*
          * Mapping a list of frames for storing grant entries. Frames 
parameter
          * is used to store grant table address when grant table being 
setup,
          * nr_gframes is the number of frames to map grant table. Returning
          * GNTST_okay means success and negative value means failure.
          */
         int (*map_frames)(unsigned long *, unsigned int);
         /*
          * Release a list of frames which are mapped in map_frames for 
grant
          * entry status.
          */
         void (*unmap_frames)(void);
         /*
          * Introducing a valid entry into the grant table, granting the 
frame
          * of this grant entry to domain for accessing, or transfering, or
          * transitively accessing. Ref parameter is reference of this 
introduced
          * grant entry, domid is id of granted domain, frame is the 
page frame
          * to be granted, and flags is status of the grant entry to be 
updated.
          */
         void (*update_entry)(grant_ref_t, domid_t, unsigned long, 
unsigned);
         /*
          * Stop granting a grant entry to domain for accessing. Ref 
parameter is
          * reference of a grant entry whose grant access will be stopped,
          * readonly is not in use in this function. If the grant entry is
          * currently mapped for reading or writing, just return 
failure(==0)
          * directly and don't tear down the grant access. Otherwise, 
stop grant
          * access for this entry and return success(==1).
          */
         int (*end_foreign_access_ref)(grant_ref_t, int);
         /*
          * Stop granting a grant entry to domain for transfer. If 
tranfer has
          * not started, just reclaim the grant entry and return 
failure(==0).
          * Otherwise, wait for the transfer to complete and then return the
          * frame.
          */
         unsigned long (*end_foreign_transfer_ref)(grant_ref_t);
         /*
          * Query the status of a grant entry. Ref parameter is reference of
          * queried grant entry, return value is the status of queried 
entry.
          * Detailed status(writing/reading) can be gotten from the 
return value
          * by bit operations.
          */
         int (*query_foreign_access)(grant_ref_t);
         /*
          * Grant a domain to access a range of bytes within the page 
referred by
          * an available grant entry. Ref parameter is grant entry reference
          * number, domid is id of grantee domain, frame is frame address of
          * subpage grant, flags is grant type and flag information, 
page_off is
          * offset of the range of bytes, and length is length of bytes 
to be
          * accessed.
          */
         void (*update_subpage_entry)(grant_ref_t, domid_t, unsigned 
long, int,
                                      unsigned, unsigned);
         /*
          * Redirect an available grant entry on domain A to another grant
          * reference of domain B, then allow domain C to use grant 
reference
          * of domain B transitively. Ref parameter is an available 
grant entry
          * reference on domain A, domid is id of domain C which 
accesses grant
          * entry transitively, flags is grant type and flag information,
          * trans_domid is id of domain B whose grant entry is finally 
accessed
          * transitively, trans_gref is grant entry transitive reference of
          * domain B.
          */
         void (*update_trans_entry)(grant_ref_t, domid_t, int, domid_t,
                                    grant_ref_t);
Thanks
Annie
> Ian.
>
>
