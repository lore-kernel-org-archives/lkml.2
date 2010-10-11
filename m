Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab0JKNwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:52:03 -0400
Received: from adelie.canonical.com ([91.189.90.139]:33811 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0JKNwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:52:01 -0400
Message-ID: <4CB3166B.8080008@ubuntu.com>
Date: Mon, 11 Oct 2010 14:51:39 +0100
From: Scott James Remnant <scott@ubuntu.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Valerie Aurora <vaurora@redhat.com>
CC: Andreas Gruenbacher <agruen@suse.de>,
        Michal Suchanek <hramrach@centrum.cz>,
        Andy Whitcroft <apw@canonical.com>,
        Scott James Remnant <scott@canonical.com>,
        Vladimir Dronnikov <dronnikov@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>, Miklos Szeredi <miklos@szeredi.hu>,
        linuxram@us.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, neilb@suse.de, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 6/7 v3] overlay: hybrid overlay filesystem prototype
References: <20100920180404.939991832@szeredi.hu> <201009281025.00727.agruen@suse.de> <20100930215114.GD490@shell> <201010011134.57594.agruen@suse.de> <20101006173141.GB18479@shell>
In-Reply-To: <20101006173141.GB18479@shell>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 06/10/2010 18:31, Valerie Aurora wrote:
> On Fri, Oct 01, 2010 at 11:34:57AM +0200, Andreas Gruenbacher wrote:
>> On Thursday 30 September 2010 23:51:15 Valerie Aurora wrote:
>>> Hm, this was a pretty basic assumption for me - that you'd want to
>>> construct a topmost image offline that would be "merged" with the
>>> lower layers.  So, for example:
>>>
>>> Topmost layer contains:
>>>
>>> /etc/hostname
>>>
>>> Lower layers contain everything else in /etc/.  So /etc/ would exist
>>> on the topmost layer at the time of union mount, but we would want it
>>> to be transparent.  But if we created a new dir *during* the union
>>> mount, it would be opaque.
>>>
>>> What was your model?
>> The prevalent use case probably is to start out with an empty topmost layer on
>> top of an existing file system.  When things are modified, changes obviously
>> go into the topmost layer.  Additional layers can later be stacked on top of
>> that, turning the previous topmost layer into a read-only lower layer.
>>
>> Overlaying preexisting file systems doesn't seem that important; users
>> commonly should be able to start out with an empty topmost layer instead.  To
> Okay, that surprises me.  Let me check my assumptions.  I cc'd several
> people who seem to be actively using unionfs or aufs in ways that we
> want union mounts to replace.  Do you start out with an empty topmost
> file system in most cases?  Or do you prepopulate with some files in
> dirs you want to be transparent?
>
Our use would be for the Live CD and for Update testing - in both of 
these scenarios I imagine that the top-most layer would start empty, yes.

Scott
