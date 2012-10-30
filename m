Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab2J3NLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 09:11:05 -0400
Received: from 5350504D.static.ziggozakelijk.nl ([83.80.80.77]:44719 "EHLO
	ns2.tasking.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2J3NLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 09:11:04 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Oct 2012 09:11:03 EDT
To: linux-kernel@vger.kernel.org
Message-ID: <508FD068.2000903@tasking.nl>
Date: Tue, 30 Oct 2012 14:04:40 +0100
From: Kees Bakker <spam@tasking.nl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Subject: kernel BUG at fs/lockd/mon.c:150, was Re: [PATCH v2 3/3] lockd: create and ...
References: <20120918093612.2469.94393.stgit@localhost.localdomain> <20120918093612.2469.94393.stgit@localhost.localdomain> <20120918093723.2469.47300.stgit@localhost.localdomain>
In-Reply-To: <20120918093723.2469.47300.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
NNTP-Posting-Host: 172.17.1.96
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-09-12 11:37, Stanislav Kinsbursky wrote:
> NSM RPC client can be required on NFSv3 umount, when child reaper is dying
> (and destroying it's mount namespace). It means, that current nsproxy is set
> to NULL already, but creation of RPC client requires UTS namespace for gaining
> hostname string.
>
> This patch creates reference-counted per-net NSM client on first monitor
> request and destroys it after last unmonitor request.
>

We're hitting the BUG_ON that was added in this patch. I've tried it with
3.6.3 and 3.6.4

It happens almost immediate when I do apt-get update (the archive is on NFS).
-- 
Kees


