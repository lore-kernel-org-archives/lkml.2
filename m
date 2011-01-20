Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab1ATQvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 11:51:48 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58533 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab1ATQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 11:51:47 -0500
Message-ID: <4D386820.5080902@austin.ibm.com>
Date: Thu, 20 Jan 2011 10:51:44 -0600
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/4] De-couple sysfs memory directories from memory sections
References: <4D386498.9080201@austin.ibm.com> <20110120164555.GA30922@kroah.com>
In-Reply-To: <20110120164555.GA30922@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 10:45 AM, Greg KH wrote:
> On Thu, Jan 20, 2011 at 10:36:40AM -0600, Nathan Fontenot wrote:
>> The root of this issue is in sysfs directory creation. Every time
>> a directory is created a string compare is done against sibling
>> directories ( see sysfs_find_dirent() ) to ensure we do not create 
>> duplicates.  The list of directory nodes in sysfs is kept as an
>> unsorted list which results in this being an exponentially longer
>> operation as the number of directories are created.
> 
> Again, are you sure about this?  I thought we resolved this issue in the
> past, but you were going to check it.  Did you?
> 

Yes, the string compare is still present in the sysfs code.  There was
discussion around this sometime last year when I sent a patch out that
stored the directory entries in something other than a linked list.
That patch was rejected but it was agreed that something should be done.

-Nathan
