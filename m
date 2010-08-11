Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0HKPTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:19:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34970 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0HKPTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:19:20 -0400
Subject: Re: [PATCH 0/8] v5 De-couple sysfs memory directories from memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Nathan Fontenot <nfont@austin.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg KH <greg@kroah.com>
In-Reply-To: <4C60407C.2080608@austin.ibm.com>
References: <4C60407C.2080608@austin.ibm.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 11 Aug 2010 08:18:52 -0700
Message-ID: <1281539932.6988.39.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 12:53 -0500, Nathan Fontenot wrote:
> This set of patches de-couples the idea that there is a single
> directory in sysfs for each memory section.  The intent of the
> patches is to reduce the number of sysfs directories created to
> resolve a boot-time performance issue.  On very large systems
> boot time are getting very long (as seen on powerpc hardware)
> due to the enormous number of sysfs directories being created.
> On a system with 1 TB of memory we create ~63,000 directories.
> For even larger systems boot times are being measured in hours. 

Hi Nathan,

The set is looking pretty good to me.  We _might_ want to up the ante in
the future and allow it to be even more dynamic than this, but this
looks like a good start to me.

BTW, have you taken a look at what the hotplug events look like if only
a single section (not filling up a whole block) is added?  

Feel free to add my:

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

