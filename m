Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1F0LBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 07:01:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62192 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab1F0K7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:59:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=f/C63AASlK5968PVoX90VgNiUDACTYJMu76V8U/oj+AsMNv1g7DJYrogBx9XgP6JwB
         evajqQ1eKdoh770YEf1sFDThDxY+QYXCuAmqyYRbHaHR+TPcZMVknkVfiqRkIsduwKLk
         Y++3SaCwbJWh5HqJHkC3AI4KtFpGH0kT+Nxk8=
Date: Mon, 27 Jun 2011 14:59:49 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        rientjes@google.com, wilsons@start.ca, security@kernel.org,
        eparis@redhat.com, kernel-hardening@lists.openwall.com,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] proc: restrict access to /proc/PID/io
Message-ID: <20110627105949.GA9260@albatros>
References: <1308917318-4749-1-git-send-email-segoon@openwall.com>
 <4E07F1C0.2070305@jp.fujitsu.com>
 <20110627070300.GA4463@albatros>
 <4E08324D.9040605@jp.fujitsu.com>
 <20110627085242.GA6635@albatros>
 <4E08565C.4080007@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E08565C.4080007@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 19:07 +0900, KOSAKI Motohiro wrote:
> I'm ok any alternative way if you have. I only want to don't break iotop.
> It's used very widely and frequently from performance tuning engineers.

It doesn't break listening for own processes statistics.  It disables
spying for alien processes.  Or is iotop does something useful using
other users' processes information?  The only thing I can think about is
watching for the related processes running under the separate account
(e.g. separate DB and web user accounts).

For performance things IMO the precise io activity is needed anyway.  If
you have to watch for other processes, you probably have to be root
(which is overkill, though).


Don't know whether it can help - I've suggested the way to define a
group allowed to read somewhat private procfs files:

http://www.openwall.com/lists/kernel-hardening/2011/06/15/19

It is incomplete (in sense of taskstats missing) and it is a bit dumb/not
configurable.  Here I suggest a bit more configurable scheme:

http://www.openwall.com/lists/kernel-hardening/2011/06/22/1


Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
