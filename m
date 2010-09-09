Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0IIL3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:29:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52153 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab0IIL3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:29:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IkSXJpCvc6Pg73BkeCpgvH2YNdUnh/ZXUCL1AfKq4ZY0ClnaelBAmXgqPZ6CLo8UXK
         BkylR3k4+HPmGSocsGPCdFVJiPMs4ZWNLImoo3Zy1IM1/ARgGoNUAH9e8HqlNoB1phFd
         DuGI3dsQdFleKSLn7hXYneF+idSokSHoMN8KE=
Date: Thu, 9 Sep 2010 13:29:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Harald Gustafsson <hgu1972@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Harald Gustafsson <harald.gustafsson@ericsson.com>,
        Song Yuan <song.yuan@ericsson.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf events over (net) console?
Message-ID: <20100909112940.GA5267@nowhere>
References: <AANLkTi=yeHyOeewm9tdsHRtj+=d+vE5=NRKGaPyq_yGH@mail.gmail.com> <1284031141.402.1.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284031141.402.1.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 01:19:01PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-09-09 at 13:06 +0200, Harald Gustafsson wrote:
> > Hi,
> > 
> > We would like to monitor the perf events continuously on a remote
> > machine. Does it exist a solution (in the kernel) to direct the output
> > to a console or maybe even a netconsole? We would like to avoid a user
> > space application to transfer it, due to that the machine will be
> > running a test which will heavily load it and we want to avoid as many
> > unrelated user space tasks as possible. If not mainlined does anyone
> > have a patch for this?
> 
> No, and its a daft requirement.
> 
> You need a process context anyway to read the data and send it to
> whatever place you want it.
> 
> Putting that in-kernel serves no purpose what so ever.


But if we bring the splice support, that can be done with minimal userspace
noise. Plus that would work with the usual sockets but not limited to that.

trace-cmd does that to carry the traces over the network.

