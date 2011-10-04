Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab1JDUwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:52:22 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:36837 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab1JDUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:52:21 -0400
Subject: Re: [RFCv3][PATCH 1/4] replace string_get_size() arrays
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com, hpa@zytor.com
In-Reply-To: <1317760957.18210.15.camel@Joe-Laptop>
References: <20111001000856.DD623081@kernel>
	 <1317497626.22613.1.camel@Joe-Laptop> <1317756942.7842.38.camel@nimitz>
	 <1317760957.18210.15.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Oct 2011 13:51:06 -0700
Message-ID: <1317761466.7842.41.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11100420-2398-0000-0000-000000B766AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-04 at 13:42 -0700, Joe Perches wrote:
> > Right, but we're only handling u64.
> 
> So the declaration should be:
> 
>         static const char byte_units[] = " KMGTPE";

I guess that's worth a comment.  But that first character doesn't get
used.  There were two alternatives:

	static const char byte_units[] = "_KMGTPE";

or something along the lines of:

+	static const char byte_units[] = "KMGTPE";
...
+	index--;
+       /* index=-1 is plain 'B' with no other unit */
+       if (index >= 0) {

We don't ever _actually_ look at the space (or underscore).  I figured
the _ was nicer since it would be _obvious_ if it ever got printed out
somehow.  

-- Dave

