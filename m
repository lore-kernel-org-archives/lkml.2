Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab2BFIMl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 03:12:41 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33595 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab2BFIMk convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 6 Feb 2012 03:12:40 -0500
Message-Id: <4F2F998202000078000714CD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 06 Feb 2012 08:12:34 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Dan Magenheimer" <dan.magenheimer@oracle.com>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>, <xen-devel@lists.xensource.com>,
        "Konrad Wilk" <konrad.wilk@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] xen/tmem: cleanup
References: <4F2C06A00200007800071071@nat28.tlf.novell.com>
 <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
In-Reply-To: <d86f0be9-1530-47bd-b3fd-8c251e563b25@default>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 04.02.12 at 17:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
>>  From: Jan Beulich [mailto:JBeulich@suse.com]
>> Subject: [PATCH] xen/tmem: cleanup
>> 
>> Use 'bool' for boolean variables. Do proper section placement.
>> Eliminate an unnecessary export.
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
>> 
>> -int tmem_enabled __read_mostly;
>> -EXPORT_SYMBOL(tmem_enabled);
>> +bool __read_mostly tmem_enabled = false;
> 
> tmem_enabled is used in xen/drivers/xen-selfballoon.c

Which can't be built as a module, and hence the symbol doesn't need
exporting. This patch (of course, I'm tempted to say) survived build
testing.

Jan

