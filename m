Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab1ATRJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 12:09:12 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:50776 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471Ab1ATRJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 12:09:10 -0500
Subject: Re: [PATCH 0/4] De-couple sysfs memory directories from memory
 sections
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Nathan Fontenot <nfont@austin.ibm.com>, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
In-Reply-To: <20110120164555.GA30922@kroah.com>
References: <4D386498.9080201@austin.ibm.com>
	 <20110120164555.GA30922@kroah.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Thu, 20 Jan 2011 09:09:01 -0800
Message-ID: <1295543341.9039.588.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 08:45 -0800, Greg KH wrote:
> On Thu, Jan 20, 2011 at 10:36:40AM -0600, Nathan Fontenot wrote:
> > The root of this issue is in sysfs directory creation. Every time
> > a directory is created a string compare is done against sibling
> > directories ( see sysfs_find_dirent() ) to ensure we do not create 
> > duplicates.  The list of directory nodes in sysfs is kept as an
> > unsorted list which results in this being an exponentially longer
> > operation as the number of directories are created.
> 
> Again, are you sure about this?  I thought we resolved this issue in the
> past, but you were going to check it.  Did you?

Just to be clear, simply reducing the number of kobjects can make these
patches worthwhile on their own.  I originally figured that the
SECTION_SIZE would go up over time as systems got larger, and _that_
would keep the number of sections and number of sysfs objects down.
Well, that turned out to be wrong, and we're eating up a ton of memory
now.  We can't fix the SECTION_SIZE easily, but we can reduce the number
of kobjects that we need to track the sections.  *That* is the main
benefit I see from these patches.

I think there's a problem worth fixing, even ignoring the directory
creation issue (if it still exists).

-- Dave

