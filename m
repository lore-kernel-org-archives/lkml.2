Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933156Ab1JDVSz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 17:18:55 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37277 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932558Ab1JDVSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 17:18:54 -0400
Message-ID: <1317763133.20800.4.camel@Joe-Laptop>
Subject: Re: [RFCv3][PATCH 1/4] replace string_get_size() arrays
From: Joe Perches <joe@perches.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com
Date: Tue, 04 Oct 2011 14:18:53 -0700
In-Reply-To: <1317761466.7842.41.camel@nimitz>
References: <20111001000856.DD623081@kernel>
	 <1317497626.22613.1.camel@Joe-Laptop> <1317756942.7842.38.camel@nimitz>
	 <1317760957.18210.15.camel@Joe-Laptop> <1317761466.7842.41.camel@nimitz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 13:51 -0700, Dave Hansen wrote:
> On Tue, 2011-10-04 at 13:42 -0700, Joe Perches wrote:
> > > Right, but we're only handling u64.
> > So the declaration should be:
> >         static const char byte_units[] = " KMGTPE";
> I guess that's worth a comment.  But that first character doesn't get
> used.  There were two alternatives:
> 	static const char byte_units[] = "_KMGTPE";

or
	static const char byte_units[] = { 0, 'K', 'M', 'G', 'T', 'P', 'E' };

and use ARRAY_SIZE(byte_units) not strlen(byte_units)
for array size maximum.

> or something along the lines of:
> +	static const char byte_units[] = "KMGTPE";
> ...
> +	index--;
> +       /* index=-1 is plain 'B' with no other unit */
> +       if (index >= 0) {
> 
> We don't ever _actually_ look at the space (or underscore).  I figured
> the _ was nicer since it would be _obvious_ if it ever got printed out
> somehow.  

shrug.  It's all the same stuff.

cheers, Joe

