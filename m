Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab0FEAVJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 20:21:09 -0400
Received: from crca.org.au ([74.207.252.120]:45956 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757507Ab0FEAVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 20:21:07 -0400
X-Bogosity: Ham, spamicity=0.020710
Message-ID: <4C099867.4050807@crca.org.au>
Date: Sat, 05 Jun 2010 10:20:55 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] [SUSPECTED SPAM] Re: Proposal for a new algorithm
 for	reading & writing a hibernation image.
References: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
In-Reply-To: <9rpccea67yy402c975fqru8r.1275576653521@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

As I think about this more, I reckon we could run into problems at 
resume time with reloading the image. Even if some bits aren't modified 
as we're writing the image, they still might need to be atomically 
restored. If we make the atomic restore part too small, we might not be 
able to do that.

So perhaps the best thing would be to stick with the way TuxOnIce splits 
the image at the moment (page cache / process pages vs 'rest'), but 
using this faulting mechanism to ensure we do get all the pages that are 
changed while writing the first part of the image.

Regards,

Nigel
