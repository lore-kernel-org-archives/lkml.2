Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab2EBReZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:34:25 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45802 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab2EBReY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:34:24 -0400
Message-ID: <4FA17015.1000504@parallels.com>
Date: Wed, 02 May 2012 21:34:13 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Sasha Levin <levinsasha928@gmail.com>
CC: "khlebnikov@openvz.org" <khlebnikov@openvz.org>,
        "gorcunov@openvz.org" <gorcunov@openvz.org>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: c/r: broken locking when executing map_files
References: <1335979380.10666.6.camel@lappy>
In-Reply-To: <1335979380.10666.6.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2012 09:23 PM, Sasha Levin wrote:
> Hi all,
> 
> I've stumbled on several lockdep warnings when playing with the new files created under /proc/[pid], specifically 'map_files'.
> 
> My theory is that files under map_files shouldn't be executable, 

These are symlinks and x bit on them doesn't mean anything, but anyway, thanks for catching this.

> but since I'm not sure what the usermode code for
> c/r does exactly, I should probably confirm that first. If it's indeed the case, you can probably skip
> the rest of this mail.
> 
> First, if I try to simply execute one of the mappings:
