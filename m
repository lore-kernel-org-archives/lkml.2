Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001Ab0EXDix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:38:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59414 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755933Ab0EXDiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:38:52 -0400
Date: Sun, 23 May 2010 20:39:00 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sundar <sunder.svit@gmail.com>
Cc: Viresh KUMAR <viresh.kumar@st.com>, Rajeev KUMAR <rajeev-dlh.kumar@st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Armando VISCONTI <armando.visconti@st.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Vipin KUMAR <vipin.kumar@st.com>, Shiraz HASHIM <shiraz.hashim@st.com>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] Power Domain Framework
Message-ID: <20100524033859.GB24480@opensource.wolfsonmicro.com>
References: <AANLkTiniwUDg8rQzwgm_X7EbkQJ9tHzBfVtaJRiNE9az@mail.gmail.com>
 <1274114107.20589.64.camel@bnru01>
 <1274115886.2698.22.camel@finisterre.wolfsonmicro.main>
 <1274118332.17303.17.camel@bnru01>
 <CEE6BB42CAD6E947908279175AF8470A025A726240@EXDCVYMBSTM006.EQ1STM.local>
 <1274131108.2698.161.camel@finisterre.wolfsonmicro.main>
 <CEE6BB42CAD6E947908279175AF8470A025A72624A@EXDCVYMBSTM006.EQ1STM.local>
 <1274134636.2698.170.camel@finisterre.wolfsonmicro.main>
 <1274162450.17303.35.camel@bnru01>
 <AANLkTinTdTp_X4lGtZ0hCaVJN5GmvI0tXR1RTRkRNkjN@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinTdTp_X4lGtZ0hCaVJN5GmvI0tXR1RTRkRNkjN@mail.gmail.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 22, 2010 at 09:32:10AM +0530, Sundar wrote:

> > operating mode for the entire power domain. For example, I can see
> > hardware requiring that if more than a given number of blocks are
> > enabled at any level a higher operating point is selected.

> To me, since such a requirement is a constraint on the regulator,
> this can be added as a flag to the regulator details.
> This flag can then be used in the set_opp* functions to check the
> condition along with the client dependencies!

This is just one example of something that might come up and need
fitting in to the regulator API which is substantially different to the
needs of the core regulator applications.  As I keep saying I'm just not
seeing much more overlap here with the regulator API than I do with the
clock API: it feels like you've got another use case which needs an API
with a similar structure and the reference counted enable and disable
calls but otherwise very little overlap.

I don't think the enable and disable calls are enough of an overlap to
mean that the regulator use case and the operating point use case are
going to overlap well, it feels like it'd cause pain trying to match the
concepts between the two APIs.
