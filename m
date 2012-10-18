Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab2JRWOL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:14:11 -0400
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:36541 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab2JRWOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:14:09 -0400
Message-ID: <50807F26.5070106@genband.com>
Date: Thu, 18 Oct 2012 16:13:58 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Alex Bligh <alex@alex.org.uk>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Local DoS through write heavy I/O on CFQ & Deadline
References: <0B138F62-16BF-4295-9AD9-64C0BB39FCE2@alex.org.uk> <20121012133044.GA10115@dhcp22.suse.cz> <E6EF14955C67D6CA58918872@nimrod.local> <20121012145838.GD22083@dhcp22.suse.cz> <3D1C85A52BB960B79E37AC30@nimrod.local> <20121018212845.GB17646@quack.suse.cz>
In-Reply-To: <20121018212845.GB17646@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Oct 2012 22:13:59.0877 (UTC) FILETIME=[DFACBF50:01CDAD7D]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19286.001
X-TM-AS-Result: No--8.423200-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 03:28 PM, Jan Kara wrote:

>    Yeah, ionice has its limitations. The problem is that all buffered
> writes happen just into memory (so completely independently of ionice
> settings). Subsequent writing of dirty memory to disk happens using flusher
> thread which is a kernel process and it doesn't know anything about IO
> priority set for task which created the file. If you wrote the file with
> oflag=direct or oflag=sync you would see that ionice works as expected.

Has anyone looked at storing the ionice value with the buffered write 
request such that the actual writes to disk could be sorted by priority 
and done with the ionice level of the original caller?

Chris
