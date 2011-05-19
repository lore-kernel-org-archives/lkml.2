Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361Ab1ESSyU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:54:20 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62416 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933819Ab1ESSyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:54:16 -0400
Date: Thu, 19 May 2011 12:54:13 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 2/6] of: Make of_find_node_by_path() traverse
 /aliases for relative paths.
Message-ID: <20110519185413.GE5109@ponder.secretlab.ca>
References: <1304614949-30460-1-git-send-email-ddaney@caviumnetworks.com>
 <1304614949-30460-3-git-send-email-ddaney@caviumnetworks.com>
 <4DC3C7FC.9050807@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC3C7FC.9050807@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 02:05:48PM +0400, Sergei Shtylyov wrote:
> Hello.
> 
> On 05-05-2011 21:02, David Daney wrote:
> 
> >Currently all paths passed to of_find_node_by_path() must begin with a
> >'/', indicating a full path to the desired node.
> 
> >Augment the look-up code so that if a path does *not* begin with '/',
> >the path is used as the name of an /aliases property.  The value of
> >this alias is then used as the full node path to be found.
> 
> >Signed-off-by: David Daney<ddaney@caviumnetworks.com>
> >---
> >  drivers/of/base.c |   41 ++++++++++++++++++++++++++++++++++++++++-
> >  1 files changed, 40 insertions(+), 1 deletions(-)
> 
> >diff --git a/drivers/of/base.c b/drivers/of/base.c
> >index 632ebae..1a0a83e 100644
> >--- a/drivers/of/base.c
> >+++ b/drivers/of/base.c
> [...]
> >@@ -348,14 +351,50 @@ EXPORT_SYMBOL(of_get_next_child);
> >  struct device_node *of_find_node_by_path(const char *path)
> >  {
> >  	struct device_node *np = allnodes;
> >+	struct device_node *aliases = NULL;
> >+	char *alias = NULL;
> >+	char *new_path = NULL;
> >
> >  	read_lock(&devtree_lock);
> >+
> >+	if (path[0] != '/') {
> >+		const char *ps;
> >+		aliases = of_find_node_by_path("/aliases");
> >+		if (!aliases)
> >+			goto out;
> >+
> >+		ps = strchr(path, '/');
> >+		if (ps) {
> >+			size_t len = ps - path;
> >+			alias = kmalloc(len + 1, GFP_KERNEL);
> 
>    How about error handling?

Yes, please add error handling and repost.

Thanks,
g.

