Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854Ab1AVMir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 07:38:47 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40300 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab1AVMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 07:38:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KtZzQQ64djR+GISjTbIhZyiGIUQ3teq3neotEQcgmiDBr3sCSmv4HbfH/jOUSfhDyV
         mshsJW7J4c7offTbGKrfLXYTvGnznk3O9u4n8syosUJOe37gM7kZamp7hmF//M6TOR29
         tBGb3s09JwzYQ963L7FgpZHjLIS1UEzEdoRHQ=
Date: Sat, 22 Jan 2011 13:38:40 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V9 08/13] posix clocks: cleanup the CLOCK_DISPTACH macro
Message-ID: <20110122123840.GA30830@riccoc20.at.omicron.at>
References: <cover.1294917347.git.richard.cochran@omicron.at>
 <90b2beef441615d01c93fcad029c44af4e505c5f.1294917348.git.richard.cochran@omicron.at>
 <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101131745400.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:03:24PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Richard Cochran wrote:
> >  int posix_cpu_clock_getres(const clockid_t which_clock, struct timespec *ts);
> >  int posix_cpu_clock_get(const clockid_t which_clock, struct timespec *ts);
> > -int posix_cpu_clock_set(const clockid_t which_clock, const struct timespec *ts);
> > +int posix_cpu_clock_set(const clockid_t which_clock, struct timespec *ts);
> 
> Shouldn't we change the clock_set function to have *ts const in all places ?

The common_clock_set function calls:

    do_sys_settimeofday
        security_settime
            cap_settime
    do_settimeofday

so all their signatures must also change.

Should I add that into my patch set?

Thanks,
Richard
