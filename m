Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab0FVLN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 07:13:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51332 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0FVLN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 07:13:57 -0400
Message-ID: <4C209AF3.2070305@suse.cz>
Date: Tue, 22 Jun 2010 13:13:55 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: Nico Schottelius <nico-linuxsetlocalversion@schottelius.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] kbuild: Clean up and speed up the localversion logic
References: <4C1764CD.3080402@suse.cz> <1276782038-23441-1-git-send-email-mmarek@suse.cz> <20100622104412.GB9779@ethz.ch>
In-Reply-To: <20100622104412.GB9779@ethz.ch>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.6.2010 12:44, Nico Schottelius wrote:
> Michal Marek [Thu, Jun 17, 2010 at 03:40:38PM +0200]:
>> -cd "${1:-.}" || usage
>> +scm_only=false
>> +srctree=.
>> +if test "$1" = "--scm-only"; then
>> +	scm_only=true
>> +	shift
>> +fi
>> +if test $# -gt 0; then
>> +	srctree=$1
> 
> You probably want
> 
> srctree="$1" 
> 
> to catch spaces and co. in the path.

That's the same, the value in variable assignment is not subject to word
splitting.


> Otherwise I just had a quick view over it, but seems to look good.

Thanks!

/me is now wondering if it's ok to push this for 2.6.35. At least, there
were no bugreports from linux-next users so far.

Michal
