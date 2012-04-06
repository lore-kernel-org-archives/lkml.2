Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab2DFFMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 01:12:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:51869 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab2DFFMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 01:12:35 -0400
Message-ID: <4F7E7B42.4070609@wwwdotorg.org>
Date: Thu, 05 Apr 2012 23:12:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCH 2/6] regmap: allow regmap instances to be named
References: <1333576113-13196-1-git-send-email-swarren@wwwdotorg.org> <1333576113-13196-2-git-send-email-swarren@wwwdotorg.org> <CAP=VYLpfssjmREbEcGMQ8P4N7wpKgv=vC++ho+UugtOsx5SxOQ@mail.gmail.com>
In-Reply-To: <CAP=VYLpfssjmREbEcGMQ8P4N7wpKgv=vC++ho+UugtOsx5SxOQ@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 09:44 PM, Paul Gortmaker wrote:
> On Wed, Apr 4, 2012 at 5:48 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> Some devices have multiple separate register regions. Logically, one
>> regmap would be created per region. One issue that prevents this is that
>> each instance will attempt to create the same debugfs files. Avoid this
>> by allowing regmaps to be named, and use the name to construct the
>> debugfs directory name.
...
> Hi Stephen,
> 
> Can you take a look at these linux-next fails?
> 
> drivers/base/regmap/regmap.c:349:2: error: too many arguments to
> function 'regmap_debugfs_init'
> drivers/base/regmap/regmap.c:434:2: error: too many arguments to
> function 'regmap_debugfs_init'
> make[4]: *** [drivers/base/regmap/regmap.o] Error 1

Oops. Sorry about that; evidently tegra_defconfig has CONFIG_DEBUG_FS
enabled and I didn't realize it. Fix posted.
